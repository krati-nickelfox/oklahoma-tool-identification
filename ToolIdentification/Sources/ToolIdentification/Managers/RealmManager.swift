//
//  RealmManager.swift
//
//
//  Created by Krati Mittal on 12/02/24.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static var shared = RealmManager()
    var schemaVersion = 1
    
    private init() {}
    
    static var realm: Realm? {
        do {
            return try Realm()
        } catch let error {
            print("Error initializing Realm: \(error)")
            return nil
        }
    }
    
    func checkForMigration() {
        let config = Realm.Configuration(
            schemaVersion: UInt64(self.schemaVersion),
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, _ in
            })
        
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
        } catch {
            print("Migration_Error:", error)
        }
    }
    
    // To check the questions that are added in the study deck
    static func questionsAddedToStudyDeck() -> Results<Question>? {
        let studyDeskChapters = realm?.objects(Question.self).filter("isAddedToStudyDeck == true")
        return studyDeskChapters
    }
    
    // See if reports are available in the database
    static func reportsAvailableForCategories() -> Results<Question>? {
        guard let realm = RealmManager.realm else { return nil }
        let identifyCategories = realm.objects(Question.self).filter("isAttempted == true AND isCorrect == true")
        return identifyCategories
    }
    
    // Clearing study deck from menu options view on home
    static func clearStudyDeck() {
        guard let realm = RealmManager.realm else {
            return
        }
        
        let studyDeckQuestions = realm.objects(Question.self).filter("isAddedToStudyDeck == true")
        
        if studyDeckQuestions.isEmpty {
            print("No questions found in the study deck.")
            return
        }
        
        do {
            try realm.write {
                for question in studyDeckQuestions {
                    question.isAddedToStudyDeck = false
                }
            }
            print("Study deck cleared successfully.")
        } catch {
            print("Error clearing study deck: \(error.localizedDescription)")
        }
    }
    
    // Clearing reports from menu options view on home
    static func clearReports() {
        guard let realm = RealmManager.realm else {
            return
        }
        
        let attemptedQuestions = realm.objects(Question.self).filter("isAttempted == true AND isCorrect == true")
        if attemptedQuestions.isEmpty {
            print("No reports found.")
            return
        }
        do {
            try realm.write {
                for question in attemptedQuestions {
                    question.isAttempted = false
                    question.isCorrect = false
                }
            }
            print("Reports cleared successfully.")
        } catch {
            print("Error clearing reports: \(error.localizedDescription)")
        }
    }
    
    // FIXME: Fetching all subcategories for now, irrespective of categoryName
    static func fetchSubcategoryNames(forCategories categories: [String]) -> [String]? {
        guard let realm = realm else {
            return nil
        }
        
        var subcategoryNames: [String] = []
        var subcategorySet: Set<String> = Set()
        
        let subcategories = realm.objects(Question.self).filter("categoryName IN %@", categories)
        
        for subcategory in subcategories {
            let subcategoryName = subcategory.subcategoryName
            if !subcategorySet.contains(subcategoryName) {
                subcategoryNames.append(subcategoryName)
                subcategorySet.insert(subcategoryName)
            }
        }
        
        return subcategoryNames
    }
    
    // To fetch categories
    static func fetchCategories() -> [String]? {
        guard let realm = realm else {
            return nil
        }
        
        var categorySet: Set<String> = Set()
        let categories = realm.objects(Question.self).map { $0.categoryName }
        
        for category in categories {
            if !categorySet.contains(category) {
                categorySet.insert(category)
            }
        }
        
        let categoryNames = Array(categorySet)
        return categoryNames
    }
    
    static func fetchCategoriesInStudyDeck() -> [String]? {
        guard let realm = realm else {
            return nil
        }
        
        var categorySet: Set<String> = Set()
        let categories = realm.objects(Question.self)
            .filter({ $0.isAddedToStudyDeck == true })
            .map { $0.categoryName }
        
        for category in categories {
            if !categorySet.contains(category) {
                categorySet.insert(category)
            }
        }
        
        let categoryNames = Array(categorySet)
        return categoryNames
    }
    
    static func fetchSubategoriesInStudyDeckFor(_ categories: [String]) -> [String]? {
        guard let realm = realm else {
            return nil
        }
        
        let subcategoryNames = realm.objects(Question.self)
            .filter("categoryName IN %@", categories)
            .filter({ $0.isAddedToStudyDeck == true })
            .map { $0.subcategoryName }
        
        return Array(Set(subcategoryNames))
    }

    func toggleStudyDeckForQuestion(_ questionId: String,
                                    added: Bool) {
        if let realm = RealmManager.realm,
           let question = realm.objects(Question.self).filter({ $0.id == questionId }).first {
            do {
                try realm.write {
                    question.isAddedToStudyDeck = added
                }
            } catch {
                
            }
        }
    }

    
    static func fetchCategoriesWithScores() -> [String: Double]? {
        guard let realm = realm else {
            return nil
        }
        var categoryScores: [String: Double] = [:]
        
        let categoryNames = Set(realm.objects(Question.self).map { $0.categoryName })
        
        for categoryName in categoryNames {
            let questionsForCategory = realm.objects(Question.self).filter("categoryName == %@", categoryName)
            let totalQuestions = Double(questionsForCategory.count)
            
            let correctlyAnsweredQuestions = questionsForCategory.filter("isCorrect == true")
            let correctAnswers = Double(correctlyAnsweredQuestions.count)
            
            let score: Double = (correctAnswers / totalQuestions) * 100.0
            
            categoryScores[categoryName] = score
        }
        
        return categoryScores
    }
    
    static func fetchSubcategoriesWithScores(for categoryName: String) -> [String: Double]? {
        guard let realm = realm else {
            return nil
        }
        var subcategoryScores: [String: Double] = [:]
        
        let subcategoryNames = Set(realm.objects(Question.self)
                                        .filter("categoryName == %@", categoryName)
                                        .map { $0.subcategoryName })
        
        for subcategoryName in subcategoryNames {
            let questionsForSubcategory = realm.objects(Question.self)
                                                .filter("categoryName == %@ AND subcategoryName == %@", categoryName, subcategoryName)
            let totalQuestions = Double(questionsForSubcategory.count)
            
            let correctlyAnsweredQuestions = questionsForSubcategory.filter("isCorrect == true")
            let correctAnswers = Double(correctlyAnsweredQuestions.count)
            
            let score: Double = (correctAnswers / totalQuestions) * 100.0
            
            subcategoryScores[subcategoryName] = score
        }
        
        return subcategoryScores
    }
    
}
