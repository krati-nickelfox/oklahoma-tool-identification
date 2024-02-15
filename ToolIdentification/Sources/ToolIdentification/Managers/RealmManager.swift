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
    
    static func reportsAvailableForCategories() -> Results<Question>? {
        guard let realm = RealmManager.realm else { return nil }
        let identifyCategories = realm.objects(Question.self).filter("isAttempted == true")
        return identifyCategories
    }
    
    // Clearing study deck from menu options view on home
    static func clearStudyDeck() {
        guard let realm = realm else {
            return
        }
        let studyDeckQuestions = realm.objects(Question.self).filter("isAddedToStudyDeck == true")
        if !studyDeckQuestions.isEmpty {
            for practiceQuestion in studyDeckQuestions {
                do {
                    try realm.write {
                        practiceQuestion.isAddedToStudyDeck = false
                    }
                } catch {
                    print("Realm Error while clearing study Deck")
                }
            }
        } else {
            print("No questions found in the study deck.")
        }
    }
    
    // Clearing reports from menu options view on home
    static func clearReports() {
        guard let realm = RealmManager.realm else {
            print("Realm is not initialized.")
            return
        }
        let attemptedQuestions = realm.objects(Question.self).filter("isAttempted == true")
        do {
            try realm.write {
                for question in attemptedQuestions {
                    question.isAttempted = false
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
}
