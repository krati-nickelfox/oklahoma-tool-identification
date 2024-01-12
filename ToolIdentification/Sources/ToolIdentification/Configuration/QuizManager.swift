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
    
    private var xmlFilePath: URL {
        self.configuration.xmlFilePath
    }
    
    init(configuration: QuizConfiguration) {
        self.configuration = configuration
    }
    
    public func initializeQuiz() {
        self.parseXML()
    }
    
    private func parseXML() {
        guard let parser = XMLParser(contentsOf: self.xmlFilePath) else {
            print(QuizError.invalidXML)
            return
        }
        parser.delegate = self
        parser.parse()
    }
    
}

// MARK: - XMLParserDelegate
extension QuizManager {
    public func parserDidStartDocument(_ parser: XMLParser) {
        print("------parsing started------")
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
