//
//  VideoLessonsList+CoreDataProperties.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 26/12/2022.
//
//

import Foundation
import CoreData


extension VideoLessonsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoLessonsList> {
        return NSFetchRequest<VideoLessonsList>(entityName: "VideoLessonsList")
    }

    @NSManaged public var details: String
    @NSManaged public var filePath: String?
    @NSManaged public var id: Int32
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var name: String
    @NSManaged public var thumbnail: String
    @NSManaged public var videoUrl: String

}

extension VideoLessonsList : Identifiable {

}
