//
//  FileObject.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

struct FileObject {

    var displayName: String
    var filename: String
    var url: URL?
    var fileExtension: String
    var mediatype: Media
    
    init(displayName: String, filename: String, url: String, mediatype: String) {
        self.displayName = displayName
        self.url = URL(string: url)
        self.fileExtension = url.fileExtension()
        self.filename = filename
        self.mediatype = mediatype.enumCaseForMedia()
    }
}
