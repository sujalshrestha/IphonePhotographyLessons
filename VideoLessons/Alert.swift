//
//  Alert.swift
//  VideoLessons
//
//  Created by Sujal Shrestha on 25/12/2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidData = AlertItem(
        title: Text("Server Error"),
        message: Text("The data received from the server was invalid."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidResponse = AlertItem(
        title: Text("Server Error"),
        message: Text("The response received from the server was invalid."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidUrl = AlertItem(
        title: Text("Server Error"),
        message: Text("There was an issue connecting to the server."),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToComplete = AlertItem(
        title: Text("Server Error"),
        message: Text("Unable to complete your request at the time."),
        dismissButton: .default(Text("OK"))
    )
}

