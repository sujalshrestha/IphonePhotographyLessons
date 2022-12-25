//
//  NetworkManager.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 25/12/2022.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    static let baseUrl = "https://iphonephotographyschool.com/test-api/"
    private let lessonUrl = baseUrl + "lessons"
    
    func getLessons(completed: @escaping (Result<[Lessons], VLError>) -> Void) {
        
        guard let url = URL(string: lessonUrl) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(LessonsModel.self, from: data)
                completed(.success(decodedResponse.lessons))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
