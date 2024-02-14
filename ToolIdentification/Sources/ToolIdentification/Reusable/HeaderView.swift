//
//  HeaderView.swift
//
//
//  Created by Chakshu Dawara on 13/02/24.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let leftButtonAction: (() -> Void)?
    let rightButtonAction: (() -> Void)?
    let leftIconName: String?
    let rightIconName: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let leftIconName = leftIconName, let leftButtonAction = leftButtonAction {
                Button(action: {
                    leftButtonAction()
                }, label: {
                    Image(leftIconName)
                        .foregroundColor(.white)
                })
                .frame(width: 24, height: 24)
            }
            
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            Spacer()
            
            if let rightIconName = rightIconName, let rightButtonAction = rightButtonAction {
                Button(action: {
                    rightButtonAction()
                }, label: {
                    Image(rightIconName)
                        .foregroundColor(.white)
                })
                .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 24)
    }
}
