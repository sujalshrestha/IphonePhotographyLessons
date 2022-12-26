//
//  VideoDownloadDelegate.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 26/12/2022.
//

import Foundation
import AVKit
import Combine

final class DownloadManager: ObservableObject {

    let isDownloading = CurrentValueSubject<Bool, Never>(false)
    let isDownloaded = CurrentValueSubject<Bool, Never>(false)

    func downloadFile(fileName: String, videoUrl: String) {
        isDownloading.send(true)
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("\(fileName).mp4")
        
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                debugPrint("Video file already exists")
                isDownloading.send(false)
            } else {
                let urlRequest = URLRequest(url: URL(string: videoUrl)!)
                
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        debugPrint("Request error: ", error)
                        self.isDownloading.send(false)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    
                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading.send(false)
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    self.isDownloading.send(false)
                                }
                            } catch let error {
                                debugPrint("Error decoding: ", error)
                                self.isDownloading.send(false)
                            }
                        }
                    }
                }
                dataTask.resume()
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
}
