//
//  LessonsList.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 25/12/2022.
//

import SwiftUI

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
    
    let lesson: Lessons
    
    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: lesson.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(4)
            } placeholder: {
                Color.gray
            }
            .frame(width: 120, height: 60)
            
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
