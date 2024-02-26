//
//  PrimaryGradientButton.swift
//
//
//  Created by Krati Mittal on 15/02/24.
//

import Foundation
import SwiftUI

struct PrimaryGradientButton: View {
    
    var title: String
    var action: () -> (Void)
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            LinearGradient(
                gradient: Gradient(colors: [Color.init(red: 1,
                                                       green: 0.854,
                                                       blue: 0.36),
                                            Color.init(red: 0.96,
                                                       green: 0.75,
                                                       blue: 0.015)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(.rect(cornerRadius: 12))
            .frame(width: UIScreen.main.bounds.width * 0.4,
                   height: 48)
            .overlay(
                Text(self.title)
                .foregroundColor(.black)
            )
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.58), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
        })
    }
}
