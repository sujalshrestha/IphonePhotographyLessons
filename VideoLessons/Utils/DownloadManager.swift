//
//  VideoDownloadDelegate.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 26/12/2022.
//

import Foundation
import AVKit
import Combine

final class DownloadManager: NSObject, ObservableObject {
    
    let isDownloading = CurrentValueSubject<Bool, Never>(false)
    let isDownloaded = CurrentValueSubject<Bool, Never>(false)
    let downloadProgress = CurrentValueSubject<Float, Never>(0)
    let showLoading = CurrentValueSubject<Bool, Never>(false)
    
    private var fileName: String = ""
    private var dataTask: URLSessionDownloadTask?

    func downloadFile(fileName: String, videoUrl: String) {
        self.fileName = fileName
        isDownloading.send(true)
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("\(fileName).mp4")
        
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                debugPrint("Video file already exists")
                isDownloading.send(false)
            } else {
                let urlRequest = URLRequest(url: URL(string: videoUrl)!)
                
                let configuration = URLSessionConfiguration.default
                let operationQueue = OperationQueue()
                let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
                
                dataTask = session.downloadTask(with: urlRequest)
                dataTask?.resume()
            }
        }
    }
    
    func checkFileExists(fileName: String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(fileName).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                isDownloaded.send(true)
            } else {
                isDownloaded.send(false)
            }
        } else {
            isDownloaded.send(false)
        }
    }
    
    func getVideoFileAsset(fileName: String) -> AVPlayerItem? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(fileName).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                let avAssest = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAssest)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    func stopDownload() {
        dataTask?.cancel()
        dataTask = nil
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        showLoading.send(true)
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        downloadProgress.send(progress)
        print(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download location: ", location)
        let videoData = readDownloadedData(of: location)
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("\(fileName).mp4")
        
        if let data = videoData, let destinationUrl = destinationUrl {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                do {
                    try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                    DispatchQueue.main.async {
                        self.isDownloading.send(false)
                        self.showLoading.send(false)
                    }
                } catch let error {
                    debugPrint("Error decoding: ", error)
                    self.isDownloading.send(false)
                    self.showLoading.send(false)
                }
            }
        }
    }
}
