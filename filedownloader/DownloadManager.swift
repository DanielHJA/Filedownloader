//
//  DownloadManager.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class DownloadManager {
    static let shared = DownloadManager()
    
    private var queue: [DownloadSession] = []
    
    func startFileDownloadWithSession(_ session: DownloadSession) {
        session.queueDelegate = self
        queue.append(session)
        startDownload()
        session.prepare = true
    }
    
    func cancelDownload() {
        if let first = queue.first, first.isDownloading {
            first.stopDownload()
            queue.removeFirst()
        }
    }
    
    private func startDownload() {
        if let first = queue.first, !first.isDownloading {
            first.startDownload()
        }
    }
    
    class func sessionWithURL(_ url: URL, delegate: DownloadSessionDelegate) -> DownloadSession {
        let session = DownloadSession()
        session.setupWithUrl(url)
        session.delegate = delegate
        return session
    }
    
}

extension DownloadManager: DownloadQueueDelegate {
    func downloadDidComplete() {
        guard let _ = queue.first else { return }
        queue.removeFirst()
        startDownload()
    }
}
