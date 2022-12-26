//
//  LessonsListViewModel.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 25/12/2022.
//

import SwiftUI

final class LessonsListViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var lessons: [VideoLessonsList] = []
    @Published var alertItem: AlertItem?
    
    func getLessons() {
        NetworkManager.shared.getLessons { result in
            DispatchQueue.main.async { [self] in
                isLoading = false
                switch result {
                case .success(let lessons):
                    saveToLocalDatabase(lessons: lessons)
                    getSavedDataFromLocalDatabase()
                    
                case .failure(let error):
                    getSavedDataFromLocalDatabase()
                    if !lessons.isEmpty { return } // only show error popup if the saved data is empty
                    switch error {
                    case .invalidData:
                        alertItem = AlertContext.invalidData
                    case .invalidResponse:
                        alertItem = AlertContext.invalidResponse
                    case .invalidUrl:
                        alertItem = AlertContext.invalidUrl
                    case .unableToComplete:
                        alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
    
    private func saveToLocalDatabase(lessons: [Lessons]) {
        let persistenceManager = PersistenceManager.shared
        
        for lesson in lessons {
            let lessonList = VideoLessonsList(context: persistenceManager.context)
            lessonList.id = Int32(lesson.id)
            lessonList.name = lesson.name
            lessonList.details = lesson.description
            lessonList.thumbnail = lesson.thumbnail
            lessonList.videoUrl = lesson.video_url
            persistenceManager.save()
        }
    }
    
    private func getSavedDataFromLocalDatabase() {
        let persistenceManager = PersistenceManager.shared
        lessons = persistenceManager.fetch(VideoLessonsList.self)
    }
}
