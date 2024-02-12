//
//  File.swift
//  
//
//  Created by Krati Mittal on 11/01/24.
//

import Foundation

public enum QuizError: Error {
    case invalidXML
    case invalidJSON
    case databaseError(Error)
}

public enum FileType {
    case XML
    case JSON
}

public struct QuizConfiguration {
    let fileName: String
    let fileType: FileType
    
    public init(fileName: String,
                fileType: FileType) {
        self.fileName = fileName
        self.fileType = fileType
    }
}

public class ToolIdentification {
    ///
    public static var quizManager: QuizManager?
    
    private init() {}
    
    /// Configures the quiz with the provided configuration
    ///
    /// - Parameter configuration: The configuration for the quiz
    public static func configure(with configuration: QuizConfiguration) {
        self.quizManager = QuizManager(configuration: configuration)
    }
    
}
