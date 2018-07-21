//
//  Extensions.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        return String(describing: type(of: self))
    }
}

extension String {
    func fileExtension() -> String {
        guard let ext = self.components(separatedBy: ".").last else { return "unknown" }
        return ext
    }
    
    func enumCaseForMedia() -> MediaType {
        guard let mediaEnum = MediaType(rawValue: self) else {
            return MediaType.unknown
        }
        return mediaEnum
    }
}

extension URL {
    func canBeOpened() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }
}
