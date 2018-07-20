//
//  Constants.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-20.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

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
        default:
            break
        }
    }
}
