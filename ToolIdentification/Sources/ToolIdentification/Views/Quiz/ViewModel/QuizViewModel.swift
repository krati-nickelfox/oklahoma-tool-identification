//
//  QuizViewModel.swift
//
//
//  Created by Krati Mittal on 15/02/24.
//

import Foundation

enum QuizEndAlertType {
    case scoreAndExit
    case quizExitConfirmation
    case none
}

public enum NavigationType {
    case quiz
    case studyDeck
    case reports
}

class QuizViewModel: ObservableObject {
    
    @Published var activeQuestionOptionList = [(Option, Optionstate)]()
    @Published var isAddedToStudyDeck: Bool = false
    @Published var quizEndAlertType: QuizEndAlertType = .none

    private var activeQuestion: Question? {
        didSet {
            self.isAttempted = false
        }
    }
    private var questions = [Question]()
    private let manager: QuizManager
    private var currentQuestionIndex = 0
    private var prevAttemptResult = false
        
    /// Result view related variables
    var tempResultDataMdel: ResultDataModel?
    var isAttempted: Bool = false

    private var attemptedOrSkippedQuestionList = [ResultQuestionDataModel]()
    
    /// Navigation related variables
    var navigationType: NavigationType
    var navigatedFromStudyDeck: Bool {
        self.navigationType == .studyDeck
    }

    init(manager: QuizManager,
         navigationType: NavigationType) {
        self.manager = manager
        self.navigationType = navigationType
    }
    
    private func didReachQuizEnd() {
        if self.attemptedOrSkippedQuestionList.isEmpty {
            // no question was attempted
            // show are you sure you want to exit alert
            self.quizEndAlertType = .quizExitConfirmation
        } else {
            // show score and exit alert
            self.tempResultDataMdel = ResultDataModel(attemptedQuestions: self.attemptedOrSkippedQuestionList)
            self.quizEndAlertType = .scoreAndExit
        }
    }
    
    func fetchQuestions() {
        //
        self.manager.resetAttemptedQuizState()
        
        if let selectedSubcategoryList = self.manager.selectedSubcategoryList {
            self.questions = (navigatedFromStudyDeck
            ? self.manager.fetchQuestionsInStudyDeckFor(subCategoryList: selectedSubcategoryList)
            : self.manager.fetchQuestionsFor(subCategoryList: selectedSubcategoryList)
            ).shuffled()
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
        guard let activeQuestion = self.activeQuestion else { return }
        // question is skipped
        if !self.isAttempted {
            self.manager.writeAttemptedQuestion(activeQuestion,
                                                isAttempted: false,
                                                isCorrect: activeQuestion.isCorrect,
                                                isSkipped: true)
            
            // save attempted question to temporary result questions list
            let questionResultDataModel = ResultQuestionDataModel(id: activeQuestionId,
                                                                  imageId: activeQuestionImageId,
                                                                  isCorrect: activeQuestion.isCorrect,
                                                                  isSkipped: !self.isAttempted,
                                                                  isAttempted: self.isAttempted,
                                                                  isAddedToStudyDeck: self.isAddedToStudyDeck,
                                                                  correctAnswer: self.correctOptionDescription,
                                                                  selectedAnswer: "")
            self.attemptedOrSkippedQuestionList.append(questionResultDataModel)
            #if DEBUG
            print("------------Question Skip Registered------------")
            print("questionId - \(questionResultDataModel.id)")
            print("imageId - \(questionResultDataModel.imageId)")
            print("isCorrect - \(questionResultDataModel.isCorrect)")
            print("isSkipped - \(questionResultDataModel.isSkipped)")
            print("isAttempted - \(questionResultDataModel.isAttempted)")
            print("isAddedToStudyDeck - \(questionResultDataModel.isAddedToStudyDeck)")
            print("correctAnswer - \(questionResultDataModel.correctAnswer)")
            print("selectedAnswer - \(questionResultDataModel.selectedAnswer)")
            #endif
        }

        // quiz end not reached
        if self.currentQuestionIndex < (self.questions.count - 1) {
            self.currentQuestionIndex += 1
            self.refreshActiveQuestion()
        } else {
            // reached quiz end
            self.didReachQuizEnd()
        }
    }
    
    var isLastQuestion: Bool {
      return self.currentQuestionIndex >= (self.questions.count - 1)
    }
    
    func didSelectOption(_ index: Int) {
        if !self.isAttempted,
           let activeQuestion = self.activeQuestion,
           let correctOption = self.activeQuestionOptionList.filter({ $0.0.id == self.activeQuestionCorrectOptionId }).first,
           let correctOptionIndex = self.activeQuestionOptionList.firstIndex(where: { $0.0.id == self.activeQuestionCorrectOptionId }) {
            self.isAttempted = true

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
                HapticFeedback.error()
            } else {
//                if self.navigatedFromStudyDeck { // remove correctly answered question from study deck
                    self.manager.toggleStudyDeckForQuestion(activeQuestion.id,
                                                            added: false)
//                }
            }
            
            //
            self.manager.writeAttemptedQuestion(activeQuestion, 
                                                isAttempted: true,
                                                isCorrect: isSelectedOptionCorrect,
                                                isSkipped: false)
            
            // save attempted question to temporary result questions list
            let questionResultDataModel = ResultQuestionDataModel(id: activeQuestionId,
                                                                  imageId: activeQuestionImageId,
                                                                  isCorrect: activeQuestion.isCorrect,
                                                                  isSkipped: !self.isAttempted,
                                                                  isAttempted: self.isAttempted,
                                                                  isAddedToStudyDeck: self.isAddedToStudyDeck,
                                                                  correctAnswer: self.correctOptionDescription,
                                                                  selectedAnswer: selectedOption.0.title)
            self.attemptedOrSkippedQuestionList.append(questionResultDataModel)
            
            #if DEBUG
            print("------------Question Attempt Registered------------")
            print("questionId - \(questionResultDataModel.id)")
            print("imageId - \(questionResultDataModel.imageId)")
            print("isCorrect - \(questionResultDataModel.isCorrect)")
            print("isSkipped - \(questionResultDataModel.isSkipped)")
            print("isAttempted - \(questionResultDataModel.isAttempted)")
            print("isAddedToStudyDeck - \(questionResultDataModel.isAddedToStudyDeck)")
            print("correctAnswer - \(questionResultDataModel.correctAnswer)")
            print("selectedAnswer - \(questionResultDataModel.selectedAnswer)")
            #endif
        }
    }
    
    func didTapStudyDeckButton() {
        if let activeQuestion = self.activeQuestion {
            self.manager.toggleStudyDeckForQuestion(activeQuestion.id,
                                                    added: !activeQuestion.isAddedToStudyDeck)
            self.isAddedToStudyDeck.toggle()
        }
    }
    
    func didTapExit() {
        self.didReachQuizEnd()
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
    
    var activeQuestionCorrectOptionId: Int {
        guard let activeQuestion = self.activeQuestion else {
            return 0
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

    private var correctOptionDescription: String {
        guard let activeQuestionCorrectAnswer = self.activeQuestionOptions.filter({ $0.id == self.activeQuestionCorrectOptionId }).first else {
            return ""
        }
        return activeQuestionCorrectAnswer.title
    }

}
