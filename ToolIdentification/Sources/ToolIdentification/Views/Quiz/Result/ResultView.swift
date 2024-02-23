//
//  ResultView.swift
//
//
//  Created by Krati Mittal on 19/02/24.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: QuizViewModel
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    /// Responsible to load quiz result information
    let dataModel: ResultDataModel
    
    init?(viewModel: QuizViewModel) {
        guard let resultDataMdel = viewModel.tempResultDataMdel else { return nil }
        self.viewModel = viewModel
        self.dataModel = resultDataMdel
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HStack {
                        VStack {}
                            .frame(width: UIScreen.main.bounds.width * 0.3)
                        
                        Spacer(minLength: 71)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(String(self.dataModel.correctQuestions))
                                    .foregroundStyle(.white)
                                Text("Correct")
                                    .foregroundStyle(Optionstate.correct.color)
                            }
                            GradientDividerView()
                            
                            HStack {
                                Text(String(self.dataModel.incorrectQuestions))
                                    .foregroundStyle(.white)
                                Text("Incorrect")
                                    .foregroundStyle(Optionstate.incorrect.color)
                            }
                            GradientDividerView()
                            
                            HStack {
                                Text(String(self.dataModel.skippedQuestions))
                                    .foregroundStyle(.white)
                                Text("Skipped")
                                    .foregroundStyle(
                                        Color.init(red: 0.96,
                                                   green: 0.75,
                                                   blue: 0.015)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Divider
                    Color.init(red: 0.321, green: 0.321, blue: 0.321)
                        .padding(.horizontal, 20)
                        .frame(height: 1)
                    
                    ForEach(self.dataModel.attemptedQuestions) { question in
                        ResultQuestionView(dataModel: question)
                            .padding(12)
                            .background {
                                Color.init(red: 0.26,
                                           green: 0.26,
                                           blue: 0.258)
                                .cornerRadius(12)
                            }
                            .overlay {
                                PrimaryGrayBorderedView()
                            }
                            .padding(.bottom, 4)
                    }
                    .shadow(color: .white.opacity(0.08), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
                    .padding(.horizontal, 12)
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: Header View
    var topHeaderView: some View {
        HeaderView(title: "Result",
                   leftButtonAction: {
            presentationMode.wrappedValue.dismiss()
        },
                   rightButtonAction: nil,
                   leftIconName: nil,
                   rightIconName: "ExitIcon")
    }
}
