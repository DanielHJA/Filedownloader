//
//  ViewController.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: .grouped)
        temp.delegate = self
        temp.dataSource = self
        temp.register(FileTableViewCell.self, forCellReuseIdentifier: FileTableViewCell.identifier())
        temp.separatorStyle = .singleLine
        temp.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
        temp.tableFooterView = UIView()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private var files: [FileObject] = {
        return [
        FileObject(displayName: "50 MB file",
                   filename: "50mb",
                   url: "http://ipv4.download.thinkbroadband.com:8080/50MB.zip"),

        FileObject(displayName: "Allrighty then!",
                   filename: "allrightythen",
                   url: "https://www.thesoundarchive.com/play-wav-files.asp?sound=ace/one/aallrighty.mp3"),
        FileObject(displayName: "It's alive!",
                   filename: "itsalive",
                   url: "https://www.thesoundarchive.com/play-wav-files.asp?sound=ace/one/alive.mp3"),
        FileObject(displayName: "Like a glove",
                   filename: "likeaglove",
                   url: "https://www.thesoundarchive.com/play-wav-files.asp?sound=ace/one/lkaglove.mp3"),
        FileObject(displayName: "Loooooser!",
                   filename: "loser",
                   url: "https://www.thesoundarchive.com/play-wav-files.asp?sound=ace/one/loser.wav"),
        FileObject(displayName: "Yes, Satan?",
                   filename: "yessatan",
                   url: "https://www.thesoundarchive.com/play-wav-files.asp?sound=ace/one/yessatan.wav"),
        FileObject(displayName: "Damn I'm good",
                   filename: "damnimgood",
                   url: "https://www.thesoundarchive.com/play-wav-files.asp?sound=ace/two/imgood.mp3")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        title = "File Downloader"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FileTableViewCell.identifier(), for: indexPath) as? FileTableViewCell else { return UITableViewCell() }
        cell.setupWithFileObject(files[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
