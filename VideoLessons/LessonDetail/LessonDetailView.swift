//
//  LessonDetailView.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 26/12/2022.
//

import UIKit
import Kingfisher

class LessonDetailUIView: UIView {
    
    var onPlay: (() -> Void)?
    var onNext: (() -> Void)?
    var onPrevious: (() -> Void)?
    var onCancel: (() -> Void)?
    
    let thumbnail: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.alpha = 0.5
        return view
    }()
    
    let playButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "play.fill")?.withTintColor(.white), for: .normal)
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let body: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    
    let nextLessonButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next lesson", for: .normal)
        return button
    }()
    
    let nextButtonChevron: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return view
    }()
    
    let previousLessonButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous lesson", for: .normal)
        return button
    }()
    
    let previousButtonChevron: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return view
    }()
    
    let progressOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let progressBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        return view
    }()
    
    let cancelDownloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupProgressView()
        observeEvents()
        progressOverlay.isHidden = true
    }
    
    func setupView() {
        addSubview(thumbnail)
        thumbnail.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        thumbnail.constraintHeight(constant: 200)
        
        addSubview(playButton)
        playButton.constraintHeight(constant: 44)
        playButton.constraintWidth(constant: 44)
        playButton.centerXAnchor.constraint(equalTo: thumbnail.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor).isActive = true
        
        addSubview(title)
        title.anchor(top: thumbnail.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        addSubview(body)
        body.anchor(top: title.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 16, bottom: 0, right: 16))
        
        addSubview(nextLessonButton)
        nextLessonButton.addSubview(nextButtonChevron)
        nextButtonChevron.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 20))
        
        nextLessonButton.anchor(top: nil, leading: nil, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nextButtonChevron.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 5))
        nextButtonChevron.centerYInSuperview()
        
        addSubview(previousLessonButton)
        previousLessonButton.addSubview(previousButtonChevron)
        previousButtonChevron.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        
        previousLessonButton.anchor(top: nil, leading: previousButtonChevron.trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 20, right: 0))
        previousButtonChevron.centerYInSuperview()
    }
    
    private func setupProgressView() {
        addSubview(progressOverlay)
        progressOverlay.fillSuperview()
        
        progressOverlay.addSubview(progressBackView)
        progressBackView.anchor(top: nil, leading: progressOverlay.leadingAnchor, bottom: nil, trailing: progressOverlay.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        progressBackView.constraintHeight(constant: 80)
        progressBackView.centerYInSuperview()
        
        progressBackView.addSubview(progressView)
        progressView.anchor(top: nil, leading: progressBackView.leadingAnchor, bottom: nil, trailing: progressBackView.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        progressView.constraintHeight(constant: 10)
        progressView.centerYAnchor.constraint(equalTo: progressBackView.centerYAnchor, constant: -10).isActive = true
        
        progressBackView.addSubview(cancelDownloadButton)
        cancelDownloadButton.anchor(top: nil, leading: nil, bottom: progressBackView.bottomAnchor, trailing: progressView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 0))
    }
    
    func configureView(lesson: VideoLessonsList?) {
        guard let lesson = lesson else { return }
        thumbnail.kf.setImage(with: URL(string: lesson.thumbnail))
        title.text = lesson.name
        body.text = lesson.details
    }
    
    private func observeEvents() {
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        nextLessonButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        previousLessonButton.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        cancelDownloadButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc func handlePlay() {
        onPlay?()
    }
    
    @objc func handleNext() {
        onNext?()
    }
    
    @objc func handlePrevious() {
        onPrevious?()
    }
    
    @objc func handleCancel() {
        onCancel?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
