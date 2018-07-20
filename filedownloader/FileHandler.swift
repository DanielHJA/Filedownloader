//
//  FileManager.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-20.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class FileHandler {
    
    fileprivate static let fileManager: FileManager = FileManager.default
    fileprivate static var documentsDirectory: URL? {
        return try! fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    class func saveFileFrom(tempLocation: URL, fileName: String, pathExtension: String, closure: @escaping ()->()) {
        guard let documentsdDirectory = documentsDirectory else { return }
        
        let audioDirectory = documentsdDirectory.appendingPathComponent("audio")

        if !fileManager.fileExists(atPath: audioDirectory.path) { // Uee path, not absolute string!
            do {
                try fileManager.createDirectory(atPath: audioDirectory.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Unable to create directory -- ERROR: \(error.localizedDescription)")
            }
        }
        
        var fileURL: URL!
        
        if !fileManager.fileExists(atPath: audioDirectory.appendingPathComponent(fileName).appendingPathExtension(pathExtension).path) {
            fileURL = audioDirectory.appendingPathComponent(fileName).appendingPathExtension(pathExtension)
        } else {
            do {
                let audio = try fileManager.contentsOfDirectory(atPath: documentsdDirectory.appendingPathComponent("audio").path)
                let existing = audio.filter { $0.components(separatedBy: "-").first! == fileName  }
                fileURL = audioDirectory.appendingPathComponent("\(fileName)-\(existing.count + 1)").appendingPathExtension(pathExtension)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        do {
            try fileManager.copyItem(at: tempLocation, to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
        listFilesInDirectory()
        closure()
    }
    
    class func listFilesInDirectory() {
        guard let documentsdDirectory = documentsDirectory else { return }
        do {
            let documents = try fileManager.contentsOfDirectory(at: documentsdDirectory, includingPropertiesForKeys: nil, options: [])
            let audio = try fileManager.contentsOfDirectory(atPath: documentsdDirectory.appendingPathComponent("audio").path)
            print(documents)
            print(audio)
        } catch {
            print(error)
        }
    }
    
}
