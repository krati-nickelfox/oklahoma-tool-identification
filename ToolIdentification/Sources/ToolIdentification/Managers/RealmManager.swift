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
    
    static func fetchStudyDeckQuestions() -> Results<Question>? {
        guard let realm = RealmManager.realm else {
            return nil
        }
        let predicate = NSPredicate(format: "isAddedToStudyDeck == true")
        let questions = realm.objects(Question.self).filter(predicate)
        
        return questions
    }
}
