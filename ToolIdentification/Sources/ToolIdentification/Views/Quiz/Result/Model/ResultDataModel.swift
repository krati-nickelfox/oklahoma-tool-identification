//
//  ResultDataModel.swift
//
//
//  Created by Krati Mittal on 22/02/24.
//

import Foundation

class ResultQuestionDataModel: Identifiable, ObservableObject {
    
    @Published var isAddedToStudyDeck: Bool

    let id: String
    let imageId: String
    let isCorrect: Bool
    let isSkipped: Bool
    let isAttempted: Bool
    let correctAnswer: String
    let selectedAnswer: String
    
    init(id: String, 
         imageId: String,
         isCorrect: Bool,
         isSkipped: Bool,
         isAttempted: Bool,
         isAddedToStudyDeck: Bool,
         correctAnswer: String,
         selectedAnswer: String) {
        self.id = id
        self.imageId = imageId
        self.isCorrect = isCorrect
        self.isSkipped = isSkipped
        self.isAttempted = isAttempted
        self.isAddedToStudyDeck = isAddedToStudyDeck
        self.correctAnswer = correctAnswer
        self.selectedAnswer = selectedAnswer
    }
    
    func toggleStudyDeck() {
        RealmManager.shared.toggleStudyDeckForQuestion(self.id,
                                                       added: !self.isAddedToStudyDeck)
        self.isAddedToStudyDeck.toggle()
    }
}

struct ResultDataModel {
    let attemptedQuestions: [ResultQuestionDataModel]

    var scorePercentage: Float {
        Float(self.correctQuestions / self.totalQuestions)
    }

    var totalQuestions: Int {
        self.attemptedQuestions.count
    }
    
    var correctQuestions: Int {
        self.attemptedQuestions.filter({ $0.isCorrect && $0.isAttempted }).count
    }
    
    var incorrectQuestions: Int {
        self.attemptedQuestions.filter({ !$0.isCorrect && $0.isAttempted }).count
    }
    
    var skippedQuestions: Int {
        self.attemptedQuestions.filter({ $0.isSkipped }).count
    }
    
    var correctPercentage: Double {
        (Double(self.correctQuestions) / Double(self.attemptedQuestions.count)) * 100
    }
    
    var incorrectPercentage: Double {
        (Double(self.incorrectQuestions) / Double(self.attemptedQuestions.count)) * 100
    }
    
    var skippedPercentage: Double {
        (Double(self.skippedQuestions) / Double(self.attemptedQuestions.count)) * 100
    }

}
