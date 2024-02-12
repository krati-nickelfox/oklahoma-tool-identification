//
//  File.swift
//  
//
//  Created by Krati Mittal on 11/01/24.
//

import Foundation

public enum QuizError: Error {
    case invalidXML
    case invalidJSON
    case databaseError(Error)
}

public enum FileType {
    case XML
    case JSON
}

public struct QuizConfiguration {
    let fileName: String
    let fileType: FileType
    let schemaVersion: Int

    public init(fileName: String,
                fileType: FileType,
                schemaVersion: Int) {
        self.fileName = fileName
        self.fileType = fileType
        self.schemaVersion = schemaVersion
    }
}
