//
//  LessonDetailVC.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 26/12/2022.
//

import UIKit
import SwiftUI
import AVKit
import Combine

struct LessonDetailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailVC
    let lesson: VideoLessonsList
    
    func makeUIViewController(context: Context) -> LessonDetailVC {
        let vc = LessonDetailVC(lesson: lesson)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailVC, context: Context) {
    }
}

class LessonDetailVC: UIViewController {
    
    let currentView = LessonDetailUIView()
    var cancellables = [AnyCancellable]()
    let lesson = CurrentValueSubject<VideoLessonsList?, Never>(nil)
    
    init(lesson: VideoLessonsList) {
        self.lesson.send(lesson)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeEvents()
        observeViewEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.parent?.navigationItem.largeTitleDisplayMode = .never
            let rightBarButton = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(self.downloadVideo))
            self.parent?.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    private func observeEvents() {
        lesson.sink { [weak self] lesson in
            self?.currentView.configureView(lesson: lesson)
        }.store(in: &cancellables)
    }
    
    @objc func downloadVideo() {
        let videoUrl = lesson.value?.videoUrl ?? ""
        let fileName = String(lesson.value?.id ?? 0)
        let downloadManager = DownloadManager()
        downloadManager.checkFileExists(fileName: fileName)
        
        downloadManager.isDownloaded.sink { isDownloaded in
            if isDownloaded {
                print("Video has been downloaded")
            } else {
                downloadManager.downloadFile(fileName: fileName, videoUrl: videoUrl)
            }
        }.store(in: &cancellables)
        
        downloadManager.isDownloading.sink { isDownloading in
            if isDownloading {
                print("Video is downloading...")
            }
        }.store(in: &cancellables)
        
    }
    
    private func observeViewEvents() {
        currentView.onPlay = { [weak self] in
            self?.openVideoPlayer()
        }
        
        currentView.onNext = { [weak self] in
            self?.gotoNextLesson()
        }
        
        currentView.onPrevious = { [weak self] in
            self?.gotoPreviousLesson()
        }
    }
    
    private func openVideoPlayer() {
        let downloadManager = DownloadManager()
        let fileName = String(lesson.value?.id ?? 0)
        downloadManager.checkFileExists(fileName: fileName)
        let fileAsset = downloadManager.getVideoFileAsset(fileName: fileName)
        
        let player = AVPlayer(playerItem: fileAsset)
        let avPlayerVC = AVPlayerViewController()
        avPlayerVC.player = player
        present(avPlayerVC, animated: true) { avPlayerVC.player?.play() }
        
        
//        if let videoUrl = URL(string: lesson.value?.videoUrl ?? "") {
//            let player = AVPlayer(url: videoUrl)
//            let avPlayerVC = AVPlayerViewController()
//            avPlayerVC.player = player
//            present(avPlayerVC, animated: true) { avPlayerVC.player?.play() }
//        }
    }
    
    private func gotoNextLesson() {
        let persistenceManager = PersistenceManager.shared
        let lessonsList = persistenceManager.fetch(VideoLessonsList.self)
        
        for (index, lessonData) in lessonsList.enumerated() {
            if (lesson.value?.id ?? 0) == lessonData.id {
                var nextIndex = index + 1
                if nextIndex >= lessonsList.count { nextIndex = 0 }
                lesson.send(lessonsList[nextIndex])
                return
            }
        }
    }
    
    private func gotoPreviousLesson() {
        let persistenceManager = PersistenceManager.shared
        let lessonsList = persistenceManager.fetch(VideoLessonsList.self)
        
        for (index, lessonData) in lessonsList.enumerated() {
            if (lesson.value?.id ?? 0) == lessonData.id {
                var previousIndex = index - 1
                if previousIndex <= 0 { previousIndex = 0 }
                lesson.send(lessonsList[previousIndex])
                return
            }
        }
    }
    
    override func loadView() {
        view = currentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
