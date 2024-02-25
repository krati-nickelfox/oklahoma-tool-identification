//
//  ResultQuestionView.swift
//
//
//  Created by Krati Mittal on 23/02/24.
//

import SwiftUI

struct ResultQuestionView: View {
    var dataModel: ResultQuestionDataModel

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(dataModel.id)
                    .foregroundStyle(
                        Color.init(red: 0.78,
                                   green: 0.784,
                                   blue: 0.792)
                    )
                
                Spacer()
            }
            .frame(height: 14)
            
            HStack(alignment: .top) {
                /// Question image view
                RoundedRectangle(cornerRadius: 5)
                    .overlay {
                        Group {
                            if let image = ImageManager.shared.getImageWithName(self.dataModel.imageId) {
                                Image(uiImage: image)
                                    .resizable()
                            } else {
                                Image(systemName: "photo.artframe")
                                    .resizable()
                            }
                        }
                        .clipShape(.rect(cornerRadius: 5))
                    }
                    .frame(width: 70, height: 46)

                /// Question Selected & Correct answer view
                VStack(alignment: .leading) {
                    Text("Correct: \(dataModel.correctAnswer)")
                        .foregroundStyle(Optionstate.correct.color)

                    if !dataModel.isCorrect && dataModel.isAttempted {
                        Text("Incorrect: \(dataModel.selectedAnswer)")
                            .foregroundStyle(Optionstate.incorrect.color)
                    }
                }
                .multilineTextAlignment(.leading)
                
                Spacer(minLength: 0)
            }
            
            HStack {
                if dataModel.isSkipped {
                    Text("Skipped")
                        .foregroundStyle(
                            Color.init(red: 0.96,
                                       green: 0.75,
                                       blue: 0.015)
                        )
                        .padding(.vertical, 7)
                }
                Spacer()
                
                /// Add to study deck button view
                self.addToStudyDeckButtonView
            }
        }
    }
    
    //MARK: Add to study deck button view
    var addToStudyDeckButtonView: some View {
        Button(action: {
            self.dataModel.didTapStudyDeckButton()
        }, label: {
            Color.init(red: 0.8,
                       green: 0.8,
                       blue: 0.8)
            .clipShape(.rect(cornerRadius: 4))
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .frame(height: 28)
            .overlay(
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 15, height: 15)
                        .border(!self.dataModel.isAddedToStudyDeck ? .white : .clear)
                        .overlay {
                            if self.dataModel.isAddedToStudyDeck {
                                Image("BoxTickMarkIcon", bundle: .module)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                            }
                        }
                    Text(self.dataModel.isAddedToStudyDeck
                         ? "Added to Study Deck"
                         : "Add to Study Deck")
                    .foregroundStyle(Color.init(red: 67/255,
                                                green: 67/255,
                                                blue: 66/255))
                    .font(.caption)
                }
                    .padding(.vertical, 7)
                    .frame(minWidth: 133)
            )
        })
    }
}
