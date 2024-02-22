//
//  ViewController.swift
//  OklahomaToolIdentification
//
//  Created by Krati Mittal on 10/01/24.
//

import UIKit
import ToolIdentification
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializePackage()
    }
    
    func initializePackage() {
        // Package Configuration
        // Feed actual Realm schema version
        let configuration = QuizConfiguration(fileName: "Questions",
                                              fileType: .JSON,
                                              schemaVersion: 1)
        ToolIdentification.configure(with: configuration)
        ToolIdentification.quizManager?.initializeQuiz()
        
        // Add home view from the package
        let swiftUIView = ReportsView()
        let vc = UIHostingController(rootView: swiftUIView)
        vc.view.frame = self.view.bounds
        vc.view.backgroundColor = UIColor.clear
        addChild(vc)
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

}

