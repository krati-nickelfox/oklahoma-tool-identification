//
//  QuizManager.swift
//  
//
//  Created by Krati Mittal on 11/01/24.
//

import Foundation
import RealmSwift

public class QuizManager: NSObject, XMLParserDelegate {
    
    /// The version of the quiz
    private static let version = "1.0.0"
    /// The configuration for the quiz
    private let configuration: QuizConfiguration
    
    var selectedCategory: String?
    var selectedSubcategoryList: [String]?

    private var fileName: String {
        self.configuration.fileName
    }
    
    private var fileType: FileType {
        self.configuration.fileType
    }
    
    var schemaVersion: Int {
        self.configuration.schemaVersion
    }
    
    init(configuration: QuizConfiguration) {
        self.configuration = configuration
        // set Realm schema version
        RealmManager.shared.schemaVersion = configuration.schemaVersion
        // check for Realm Migration
        RealmManager.shared.checkForMigration()
    }
    
    public func initializeQuiz() {
        if self.fileType == .XML {
            self.parseXML()
        } else {
            let jsonParsed = UserDefaults.standard.bool(forKey: "jsonParsed")
            if !jsonParsed {
                self.parseJSON()
                UserDefaults.standard.set(true, forKey: "jsonParsed")
            }
        }
    }
    
    /// Parses xml file from the given path
    private func parseXML() {
        guard let xmlFilePath = Bundle.main.url(forResource: self.fileName,
                                                withExtension: "xml"),
              let parser = XMLParser(contentsOf: xmlFilePath) else {
            print(QuizError.invalidXML)
            return
        }
        parser.delegate = self
        parser.parse()
    }
    
    private func parseJSON() {
        guard let url = Bundle.main.url(forResource: self.fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print(QuizError.invalidJSON)
            return
        }
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            print("------JSON PARSING STARTED------\n")
            
            if let categoriesData = try? JSONDecoder().decode([Question].self, from: data),
               let realm = RealmManager.realm {
                
                // Write categories to Realm database
                try realm.write {
                    realm.add(categoriesData)
                }
                print("------SAVED DATA TO REALM------\n")

                #if DEBUG
                // Access questions in Realm
                let questions = realm.objects(Question.self)
                print("------FETCHING DATA BACK FROM REALM------\n")

                for question in questions {
                    print("Category: \(question.categoryName)")
                    print("Subcategory: \(question.subcategoryName)")
                    
                    print("Question: \(question.descriptionText)")
                    print("Options:")
                    for option in question.options {
                        print(" - \(option.title)")
                    }
                    print("Correct Option: \(question.correctOption)")
                    print("Added to Study Deck: \(question.isAddedToStudyDeck)")
                }
                #endif
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - XMLParserDelegate
extension QuizManager {
    public func parserDidStartDocument(_ parser: XMLParser) {
        print("------XML parsing started------\n")
    }
    
    public func parser(_ parser: XMLParser,
                       didStartElement
                       elementName: String, 
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String: String]) {
        print(elementName)
    }
    
    public func parser(_ parser: XMLParser, 
                       didEndElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?) {
        print(elementName)
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        print("------parsing ended------")
    }
}

//
extension QuizManager {
    func fetchAllQuestions() -> [Question] {
        var questions = [Question]()
        if let realm = RealmManager.realm {
            // Access questions in Realm
            questions = Array(realm.objects(Question.self))
        }
        return questions
    }
    
    func fetchQuestionsFor(subCategoryList: [String]) -> [Question] {
        var questions = [Question]()
        if let realm = RealmManager.realm {
            questions = Array(realm.objects(Question.self)
                .filter("subcategoryName IN %@", subCategoryList))
        }
        return questions
    }
    
    func fetchQuestionsInStudyDeckFor(subCategoryList: [String]) -> [Question] {
        var questions = [Question]()
        if let realm = RealmManager.realm {
            questions = realm.objects(Question.self)
                .filter("subcategoryName IN %@", subCategoryList)
                .filter({ $0.isAddedToStudyDeck == true })
        }
        return Array(questions)
    }
    
    func resetAttemptedQuizState() {
        if let realm = RealmManager.realm {
            let questions = Array(realm.objects(Question.self))
            
            do {
                try realm.write {
                    questions.forEach { question in
                        question.isSkipped = false
                    }
                }
            } catch {
                
            }
        }
    }
    
    func writeAttemptedQuestion(_ question: Question, 
                                isAttempted: Bool,
                                isCorrect: Bool,
                                isSkipped: Bool) {
        if let realm = RealmManager.realm {
            do {
                try realm.write {
                    question.isAttempted = isAttempted
                    question.isCorrect = isCorrect
                    question.isSkipped = isSkipped
                }
            } catch {
                
            }
        }
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
                print("Error : ", error.localizedDescription)
            }
        }
    }
}
