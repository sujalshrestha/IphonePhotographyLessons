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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        observeEvents()
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
        
        nextLessonButton.anchor(top: body.bottomAnchor, leading: nil, bottom: nil, trailing: nextButtonChevron.leadingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 5))
        nextButtonChevron.centerYInSuperview()
    }
    
    func configureView(lesson: VideoLessonsList) {
        thumbnail.kf.setImage(with: URL(string: lesson.thumbnail))
        title.text = lesson.name
        body.text = lesson.details
    }
    
    private func observeEvents() {
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    }
    
    @objc func handlePlay() {
        onPlay?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
