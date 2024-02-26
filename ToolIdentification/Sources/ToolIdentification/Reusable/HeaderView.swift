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

    init(
        title: String,
        leftButtonAction: (() -> Void)? = nil,
        rightButtonAction: (() -> Void)? = nil,
        leftIconName: String? = nil,
        rightIconName: String? = nil
    ) {
        self.title = title
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.leftIconName = leftIconName
        self.rightIconName = rightIconName
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let leftIconName = leftIconName,
               let leftButtonAction = leftButtonAction {
                Button(action: {
                    leftButtonAction()
                }, label: {
                    Image(leftIconName, bundle: .module)
                        .foregroundColor(.white)
                })
                .frame(width: 24, height: 24)
            }

            Text(title)
                .font(.title)
                .foregroundColor(.white)
                .bold()

            Spacer()

            if let rightIconName = rightIconName,
               let rightButtonAction = rightButtonAction {
                if let systemImageName = UIImage(systemName: rightIconName) {
                    Button(action: {
                        rightButtonAction()
                    }, label: {
                        Image(systemName: rightIconName)
                            .foregroundColor(.white)
                    })
                    .frame(width: 24, height: 24)
                } else {
                    Button(action: {
                        rightButtonAction()
                    }, label: {
                        Image(rightIconName, bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    })
                }
            }
        }
        .padding(.horizontal, 24)
    }
}
