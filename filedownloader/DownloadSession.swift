//
//  DownloadSession.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum DownloadState {
    case pending, downloading, completed, error(Error), cancelled
}

protocol DownloadQueueDelegate: class {
    func downloadDidComplete()
}

protocol DownloadSessionDelegate: class {
    func downloadDidComplete()
    func downloadProgress(_ progress: CGFloat)
    func downloadState(_ state: DownloadState)
}

class DownloadSession: NSObject {
    
    weak var delegate: DownloadSessionDelegate?
    weak var queueDelegate: DownloadQueueDelegate?

    private var task: URLSessionDownloadTask?

    var isDownloading: Bool = false
    var userCancelledDownload: Bool = false
    
    var prepare: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.downloadState(.pending)
            }
        }
    }
    
    func setupWithUrl(_ url: URL) {
        let configuration = URLSessionConfiguration.default//background(withIdentifier: "com.downloader.background")
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let request = URLRequest(url: url)
        task = session.downloadTask(with: request)
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
        // Add filestuff
        DispatchQueue.global().async(qos: .background) {
            self.queueDelegate?.downloadDidComplete()
            DispatchQueue.main.async {
                self.delegate?.downloadDidComplete()
                self.delegate?.downloadState(.completed)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }
        if !userCancelledDownload {
            DispatchQueue.main.async {
                self.delegate?.downloadState(.error(error))
            }
        }
    }
}
