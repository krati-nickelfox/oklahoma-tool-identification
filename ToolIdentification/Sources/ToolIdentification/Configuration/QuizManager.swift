//
//  QuizManager.swift
//  
//
//  Created by Krati Mittal on 11/01/24.
//

import Foundation

public class QuizManager: NSObject, XMLParserDelegate {
    
    /// The version of the quiz
    private static let version = "1.0.0"
    /// The configuration for the quiz
    private let configuration: QuizConfiguration
    
    private var fileName: String {
        self.configuration.fileName
    }
    
    private var fileType: FileType {
        self.configuration.fileType
    }
    
    init(configuration: QuizConfiguration) {
        self.configuration = configuration
    }
    
    public func initializeQuiz() {
        if self.fileType == .XML {
            self.parseXML()
        } else {
            self.parseJSON()
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
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("------JSON parsing started------")
            if let chapters = json as? [[String: Any]] {
                print(chapters)
            }
        } catch {
            print(QuizError.invalidJSON)
        }
    }
    
}

// MARK: - XMLParserDelegate
extension QuizManager {
    public func parserDidStartDocument(_ parser: XMLParser) {
        print("------XML parsing started------")
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
