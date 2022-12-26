//
//  LessonsList.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 25/12/2022.
//

import SwiftUI
import Kingfisher

struct LessonsListView: View {
    
    @StateObject var viewModel = LessonsListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading { ProgressView() }
                List(viewModel.lessons, id: \.id) { lesson in
                    NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                        LessonListCell(lesson: lesson)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Lessons")
        }
        .onAppear() {
            viewModel.getLessons()
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton
            )
        }
    }
}

struct LessonListCell: View {
    
    let lesson: VideoLessonsList
    
    var body: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: lesson.thumbnail))
                .placeholder {
                    Color.gray
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 60)
                .cornerRadius(4)
            
            Text(lesson.name)
        }
        .padding(10)
    }
}

struct LessonsListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView()
    }
}
