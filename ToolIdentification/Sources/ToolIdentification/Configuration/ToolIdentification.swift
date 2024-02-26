//
//  ToolIdentification.swift
//
//
//  Created by Krati Mittal on 12/02/24.
//

import Foundation

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
