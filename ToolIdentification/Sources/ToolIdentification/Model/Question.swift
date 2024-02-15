//
//  Question.swift
//
//
//  Created by Krati Mittal on 12/02/24.
//

import RealmSwift

class Question: Object, Decodable, Identifiable {
    @Persisted var categoryName: String
    @Persisted var subcategoryName: String
    @Persisted var id: String
    @Persisted var imageId: String
    @Persisted var descriptionText: String = ""
    @Persisted var imageCourtesy: String = "IFSTA"
    @Persisted var correctOption: String = "0"
    @Persisted var isCorrect: Bool
    @Persisted var isAttempted: Bool
    @Persisted var isSkipped: Bool
    @Persisted var isAddedToStudyDeck: Bool
    @Persisted var options: List<Option> = List<Option>()
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageId
        case categoryName
        case subcategoryName
        case descriptionText = "description"
        case imageCourtesy
        case optionA
        case optionB
        case optionC
        case optionD
        case correctOption
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        categoryName = try container.decode(String.self, forKey: .categoryName)
        subcategoryName = try container.decode(String.self, forKey: .subcategoryName)
        imageId = try container.decode(String.self, forKey: .imageId)
        descriptionText = try container.decode(String.self, forKey: .descriptionText)
        imageCourtesy = try container.decode(String.self, forKey: .imageCourtesy)
        
        let optionA = try container.decode(String.self, forKey: .optionA)
        let optionB = try container.decode(String.self, forKey: .optionB)
        let optionC = try container.decode(String.self, forKey: .optionC)
        let optionD = try container.decode(String.self, forKey: .optionD)
        
        options.append(objectsIn: [
            Option(id: "0", title: optionA),
            Option(id: "1", title: optionB),
            Option(id: "2", title: optionC),
            Option(id: "3", title: optionD)
        ])
        
        correctOption = try container.decode(String.self, forKey: .correctOption)
    }
}

class Option: Object, Codable {
    @Persisted var id: String = "0"
    @Persisted var title: String = ""

    convenience init(id: String,
                     title: String) {
        self.init()
        self.id = id
        self.title = title
    }
}
