//
//  LessonDetailVC.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 26/12/2022.
//

import UIKit
import SwiftUI
import Combine
import AVKit

struct LessonDetailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailVC
    let lesson: Lessons
    
    func makeUIViewController(context: Context) -> LessonDetailVC {
        let vc = LessonDetailVC(lesson: lesson)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailVC, context: Context) {
    }
}

class LessonDetailVC: UIViewController {
    
    let currentView = LessonDetailUIView()
    let lesson: Lessons
    
    init(lesson: Lessons) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentView.configureView(lesson: lesson)
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
    
    @objc func downloadVideo() {
        
    }
    
    private func observeViewEvents() {
        currentView.onPlay = { [weak self] in
            self?.openVideoPlayer()
        }
    }
    
    private func openVideoPlayer() {
        if let videoUrl = URL(string: lesson.video_url) {
            let player = AVPlayer(url: videoUrl)
            let avPlayerVC = AVPlayerViewController()
            avPlayerVC.player = player
            present(avPlayerVC, animated: true) { avPlayerVC.player?.play() }
        }
    }
    
    override func loadView() {
        view = currentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
