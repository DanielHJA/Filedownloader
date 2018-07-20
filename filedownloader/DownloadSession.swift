//
//  DownloadSession.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol DownloadQueueDelegate: class {
    func downloadDidComplete()
}

protocol DownloadSessionDelegate: class {
    func downloadProgress(_ progress: CGFloat)
    func downloadState(_ state: DownloadState)
}

class DownloadSession: NSObject {
    
    weak var delegate: DownloadSessionDelegate?
    weak var queueDelegate: DownloadQueueDelegate?

    private var task: URLSessionDownloadTask?
    private var object: FileObject!
    private var userCancelledDownload: Bool = false

    var isDownloading: Bool = false
    var prepare: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.downloadState(.pending)
            }
        }
    }
    
    func setupWithObject(_ object: FileObject) {
        self.object = object
        guard let url = object.url else {
            delegate?.downloadState(.error(.invalidURL))
            return
        }
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "\(url.absoluteString).background")
        configuration.sessionSendsLaunchEvents = true // Wakes up app when download completes
        //configuration.isDiscretionary = false // Set to true to wait for optimal conditions (wifi etc.)
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        let request = URLRequest(url: url)
        task = session.downloadTask(with: request)
        // task?.earliestBeginDate = Date().addingTimerInterval(60 * 60) // Set to schedule download at least 1 hour ->
        // task?.countOfBytesClientExpectsToReceive = 200 // Set approximate bytes to be recieved
        // task?.countOfBytesClientExpectsToSend = 200 // Set approximate bytes to be sent
    }
    
    func startDownload() {
        guard let task = task else { return }
        isDownloading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            DispatchQueue.global().async(qos: .background) {
                task.resume()
                DispatchQueue.main.async {
                    self.delegate?.downloadState(.downloading)
                }
            }
        }
    }
    
    func stopDownload() {
        userCancelledDownload = true
        DispatchQueue.global().async(qos: .background) {
            self.task?.cancel()
            DispatchQueue.main.async {
                self.delegate?.downloadState(.cancelled)
            }
        }
    }
    
}

extension DownloadSession: URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        print("session \(session), downloaded \(progress)")
        
        DispatchQueue.main.async {
            self.delegate?.downloadProgress(CGFloat(progress))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        FileHandler.saveFileFrom(tempLocation: location, fileName: object.filename, pathExtension: object.fileExtension) {
            DispatchQueue.global().async(qos: .background) {
                self.queueDelegate?.downloadDidComplete()
                DispatchQueue.main.async {
                    self.delegate?.downloadState(.completed)
                }
            }
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("calling completionHandler")
        let sessionIdentifier = session.configuration.identifier
        if let sessionID = sessionIdentifier, let app = UIApplication.shared.delegate as? AppDelegate, let handler = app.backgroundCompletionHandlers.removeValue(forKey: sessionID) {
            handler()
            self.delegate?.downloadState(.completed)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }
        if !userCancelledDownload {
            DispatchQueue.main.async {
                self.delegate?.downloadState(.error(.systemError(error)))
            }
        }
    }
}
