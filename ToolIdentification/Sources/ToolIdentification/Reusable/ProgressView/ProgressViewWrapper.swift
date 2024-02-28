//
//  File.swift
//  
//
//  Created by Krati Mittal on 25/02/24.
//

import UIKit
import SwiftUI

struct ProgressViewWrapper: UIViewControllerRepresentable {
    
    let dataModel: ResultDataModel
    
    func makeUIViewController(context: Context) -> CustomProgressViewController {
        let vc = CustomProgressViewController.newInstance
        vc.dataModel = self.dataModel
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.superViewWidth = 300
        } else {
            vc.superViewWidth = 112
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CustomProgressViewController, context: Context) {
        
    }
}
