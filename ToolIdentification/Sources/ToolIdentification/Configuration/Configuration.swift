//
//  File.swift
//  
//
//  Created by Krati Mittal on 11/01/24.
//

import Foundation

public enum QuizError: Error {
    case invalidXML
    case databaseError(Error)
}

public struct QuizConfiguration {
    let xmlFilePath: URL
    
    public init(xmlFilePath: URL) {
        self.xmlFilePath = xmlFilePath
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
