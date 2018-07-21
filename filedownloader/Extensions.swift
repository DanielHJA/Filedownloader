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
    
    func enumCaseForMedia() -> Media {
        guard let mediaEnum = Media(rawValue: self) else {
            return Media.unknown
        }
        return mediaEnum
    }
}

extension FileManager {
    static func contentInDirectoryForMedia(_ media: Media, showPaths: Bool) -> [Any]? {
        var url: URL!
        var results: [Any] = []
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
       
        if media == .media {
             url = directory.appendingPathComponent(media.rawValue)
        } else {
            url = directory.appendingPathComponent(Media.media.rawValue).appendingPathComponent(media.rawValue)
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            
            do {
                if showPaths {
                    results = try FileManager.default.contentsOfDirectory(atPath: url.path)
                } else {
                    results = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
                }
                return results
                
            } catch {
                print(error)
            }
        }
        return nil
    }
}

extension URL {
    func canBeOpened() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }
}
