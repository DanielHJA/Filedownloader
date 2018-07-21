//
//  Constants.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-20.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum MediaType: String {
    case audio, video, image, unknown
    func systemPath() -> String {
        switch self {
        case .audio:
            return "audio"
        case .video:
            return "videos"
        case .image:
            return "images"
        case .unknown:
            return "unknown"
        }
    }
}

enum DownloadState {
    case pending, downloading, completed, error(CustomError), cancelled
}

enum CustomError: Error {
    case invalidURL, systemError(Error)
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .systemError(let error):
            return error.localizedDescription
        }
    }
}
