//
//  QuizViewModel.swift
//
//
//  Created by Krati Mittal on 15/02/24.
//

import Foundation

class QuizViewModel: ObservableObject {
    
    @Published var activeQuestionOptionList = [(Option, Optionstate)]()
    @Published var isAddedToStudyDeck = false
    
    private var activeQuestion: Question?
    private var questions = [Question]()
    private let manager: QuizManager
    private var currentQuestionIndex = 0
        
    init(manager: QuizManager) {
        self.manager = manager
    }
    
    func fetchQuestions() {
        //
        self.manager.resetAttemptedQuizState()

        let allQuestions = self.manager.fetchAllQuestions()
        
        if let selectedSubcategoryList = self.manager.selectedSubcategoryList {
            selectedSubcategoryList.forEach { subcategory in
                self.questions.append(contentsOf: allQuestions
                    .filter({
                        $0.subcategoryName.lowercased() == subcategory.lowercased()
                    }).shuffled())
            }
        }
        if !self.questions.isEmpty {
            self.refreshActiveQuestion()
        }
    }
    
    func refreshActiveQuestion() {
        self.isAddedToStudyDeck = false
        self.activeQuestion = self.questions[currentQuestionIndex]
        self.activeQuestionOptionList = self.activeQuestionOptions
            .map({ ($0, .none) })
            .shuffled()
    }
    
    func didTapNext() {
        self.currentQuestionIndex += 1
        if self.currentQuestionIndex < self.questions.count {
            if !self.isAttempted,
               let activeQuestion = self.activeQuestion {
                //
                self.manager.writeAttemptedQuestion(activeQuestion,
                                                    isAttempted: false,
                                                    isCorrect: activeQuestion.isCorrect,
                                                    isSkipped: true)
            }
            self.refreshActiveQuestion()
        }
    }
    
    func didSelectOption(_ index: Int) {
        if !self.isAttempted,
           let activeQuestion = self.activeQuestion,
           let correctOption = self.activeQuestionOptionList.filter({ $0.0.id == self.activeQuestionCorrectOptionId }).first,
           let correctOptionIndex = self.activeQuestionOptionList.firstIndex(where: { $0.0.id == self.activeQuestionCorrectOptionId }) {
            
            let selectedOption = self.activeQuestionOptionList[index]
            let isSelectedOptionCorrect = index == correctOptionIndex
            
            self.activeQuestionOptionList[index] = (selectedOption.0,
                                                    isSelectedOptionCorrect
                                                    ? .correct
                                                    : .incorrect)
            // hilight the correct answer
            if !isSelectedOptionCorrect {
                self.activeQuestionOptionList[correctOptionIndex] = (correctOption.0,
                                                                     .correct)
                //
                self.manager.toggleStudyDeckForQuestion(activeQuestion.id,
                                                        added: true)
                self.isAddedToStudyDeck = true
            }
            
            //
            self.manager.writeAttemptedQuestion(activeQuestion, 
                                                isAttempted: true,
                                                isCorrect: isSelectedOptionCorrect,
                                                isSkipped: false)
        }
    }
    
    func didTapStudyDeckButton() {
        if let activeQuestion = self.activeQuestion {
            self.manager.toggleStudyDeckForQuestion(activeQuestion.id,
                                                    added: !activeQuestion.isAddedToStudyDeck)
            self.isAddedToStudyDeck.toggle()
        }
    }
    
}

// MARK: Active Question details
extension QuizViewModel {
    var isQuizLoaded: Bool {
        self.activeQuestion != nil
    }
    
    var totalQuestionCount: Int {
        self.questions.count
    }
    
    var currentQuestionNumber: Int {
        self.currentQuestionIndex + 1
    }
    
    var activeQuestionId: String {
        guard let activeQuestion = self.activeQuestion else {
            return ""
        }
        return activeQuestion.id
    }
    
    var activeQuestionCorrectOptionId: String {
        guard let activeQuestion = self.activeQuestion else {
            return ""
        }
        return activeQuestion.correctOption
    }

    var activeQuestionDescription: String {
        guard let activeQuestion = self.activeQuestion else {
            return ""
        }
        return activeQuestion.descriptionText
    }

    var activeQuestionImageId: String {
        guard let activeQuestion = self.activeQuestion else {
            return ""
        }
        return activeQuestion.imageId
    }
    
    var activeQuestionImageCurtsy: String {
        guard let activeQuestion = self.activeQuestion else {
            return ""
        }
        return activeQuestion.imageCourtesy
    }
    
    var isAttempted: Bool {
        guard let activeQuestion = self.activeQuestion else {
            return false
        }
        return activeQuestion.isAttempted
    }
    
    var isSkipped: Bool {
        guard let activeQuestion = self.activeQuestion else {
            return false
        }
        return activeQuestion.isSkipped
    }
    
    private var activeQuestionOptions: [Option] {
        guard let activeQuestion = self.activeQuestion else {
            return []
        }
        return Array(activeQuestion.options)
    }

}
