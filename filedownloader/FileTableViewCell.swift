//
//  FileTableViewCell.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-18.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    var url: URL?
    
    private lazy var loadingBar: LoadingBar = {
        let temp = LoadingBar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 3.0))
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        return temp
    }()
    
    private lazy var startDownloadButton: UIButton = {
        let temp = UIButton()
        temp.setTitle("Download", for: .normal)
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        temp.backgroundColor = UIColor.blue
        temp.addTarget(self, action: #selector(didPressDownload(_:)), for: .touchUpInside)
        temp.layer.cornerRadius = 20.0
        temp.clipsToBounds = true
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        temp.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        temp.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        temp.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return temp
    }()
    
    private lazy var downloadButton: DownloadButton = {
        let temp = DownloadButton(frame: CGRect(x: 0, y: 0, width: frame.height * 0.5, height: frame.height * 0.5))
        temp.addTarget(self, action: #selector(didPressCancel(_:)), for: .touchUpInside)
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        temp.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        temp.centerXAnchor.constraint(equalTo: startDownloadButton.centerXAnchor).isActive = true
        temp.centerYAnchor.constraint(equalTo: startDownloadButton.centerYAnchor).isActive = true
        return temp
    }()
    
    private lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = UIColor.black
        temp.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        temp.numberOfLines = 1
        temp.lineBreakMode = .byTruncatingTail
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.bottomAnchor.constraint(equalTo: loadingBar.topAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor).isActive = true
        temp.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0).isActive = true
        temp.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.4).isActive = true
        return temp
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWithFileObject(_ object: FileObject) {
        selectionStyle = .none
        startDownloadButton.isHidden = false
        loadingBar.isHidden = false
        titleLabel.text = object.displayName
        url = object.url
    }
    
    @objc private func didPressCancel(_ sender: DownloadButton) {
        if sender.isUserInteractionEnabled {
            DownloadManager.shared.cancelDownload()
        }
    }
    
    @objc private func didPressDownload(_ sender: UIButton) {
        guard let url = url, url.canBeOpened() else { return } // Make UI change
        let session = DownloadManager.sessionWithURL(url, delegate: self)
        DownloadManager.shared.startFileDownloadWithSession(session)
    }
}

extension FileTableViewCell: DownloadSessionDelegate {
   
    func downloadDidComplete() {
        loadingBar.finished = true
    }
    
    func downloadProgress(_ progress: CGFloat) {
        loadingBar.progress = progress
    }
    
    func downloadState(_ state: DownloadState) {
        downloadButton.downloadState = state
        startDownloadButton.isHidden = true
        downloadButton.isHidden = false

        switch state {
        case .pending:
            print("Download is pending")
        case .downloading:
            print("Downloading")
        case .completed:
            print("Download completed")
            downloadButton.removeFromSuperview()
            // Remove cell
        case .error:
            print("There was an error with the download")
            resetCell()
        case .cancelled:
            print("The user has stopped the download")
            resetCell()
        }
    }
    
    private func resetCell() {
        downloadButton.isHidden = true
        startDownloadButton.isHidden = false
        loadingBar.progress = 0.0
    }
}
