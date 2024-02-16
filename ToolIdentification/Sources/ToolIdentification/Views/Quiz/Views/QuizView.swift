//
//  QuizView.swift
//
//
//  Created by Krati Mittal on 13/02/24.
//

import SwiftUI

public struct QuizView: View {
    
    @ObservedObject var viewModel: QuizViewModel
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    public init?() {
        guard let manager = ToolIdentification.quizManager else {
            return nil
        }
        self.viewModel = QuizViewModel(manager: manager)
    }

    public var body: some View {
        ZStack(alignment: self.viewModel.isQuizLoaded
               ? .bottom
               : .center) {
            /// Background
            Color(red: 0.15, green: 0.14, blue: 0.14)
                .ignoresSafeArea()

            if self.viewModel.isQuizLoaded {
                VStack {
                    /// Header View
                    self.topHeaderView
                        .padding(.bottom, 24)
                    
                    self.questionCountDetailView
                    
                    self.optionListView
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
                .ignoresSafeArea(edges: .bottom)

                /// Next Button
                self.actionButton
            }
            
            if !self.viewModel.isQuizLoaded {
                ProgressView()
                    .tint(.white)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.viewModel.fetchQuestions()
            }
        }
    }
    
    // MARK: Header View
    var topHeaderView: some View {
        HeaderView(title: "Tool Identification",
                   leftButtonAction: {
            presentationMode.wrappedValue.dismiss()
        },
                   rightButtonAction: {
            presentationMode.wrappedValue.dismiss()
        },
                   leftIconName: "back-icon",
                   rightIconName: "ExitIcon")
    }
    
    var questionCountDetailView: some View {
        HStack {
            Text("Question \(self.viewModel.currentQuestionNumber) of \(self.viewModel.totalQuestionCount)")
                .foregroundStyle(Color(red: 0.96, green: 0.75, blue: 0.015))
            
            Spacer()
            
            Text(self.viewModel.activeQuestionId)
                .foregroundStyle(Color(red: 0.63, green: 0.63, blue: 0.63))
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 20)
        .frame(height: 17)
    }
    
    // MARK:
    var optionListView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                /// Tool Image
                self.toomImageView
                
                /// Tool Description
                Text(self.viewModel.activeQuestionDescription)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.bottom, 16)
                
                /// Add To Study Deck
                self.addToStudyDeckButtonView
                
                /// Options list
                VStack(spacing: 20) {
                    ForEach(0..<self.viewModel.activeQuestionOptionList.count,
                            id: \.self) { index in
                        let (option, optionState) = self.viewModel.activeQuestionOptionList[index]
                        
                        OptionView(option: option,
                                   optionState: optionState)
                            .onTapGesture {
                                self.viewModel.didSelectOption(index)
                            }
                    }
                }

            }
            Spacer(minLength: 48)
        }
    }
    
    // MARK:
    var toomImageView: some View {
        ZStack {
            Image(systemName: "photo.artframe")
                .resizable()
                .clipShape(.rect(cornerRadius: 12))
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    HStack(spacing: 7) {
                        Image("ImageCurtsyIcon", bundle: .module)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .opacity(0.6)
                        
                        Text(self.viewModel.activeQuestionImageCurtsy)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.275)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [.white,
                                                .clear]),
                    startPoint: .top,
                    endPoint: .bottomTrailing
                ), lineWidth: 1.0)
        }
        .padding(1)
        .shadow(color: .white.opacity(0.08), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
    }
    
    var addToStudyDeckButtonView: some View {
        Button(action: {
            self.viewModel.didTapStudyDeckButton()
        }, label: {
            Color.init(red: 0.96,
                       green: 0.75,
                       blue: 0.015)
            .clipShape(.rect(cornerRadius: 4))
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .frame(height: 28)
            .overlay(
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 15, height: 15)
                        .border(.white)
                        .overlay {
                            if self.viewModel.isAddedToStudyDeck {
                                Image("BoxTickMarkIcon", bundle: .module)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                            }
                        }
                    Text(self.viewModel.isAddedToStudyDeck
                         ? "Added to Study Deck"
                         : "Add to Study Deck")
                    .foregroundColor(.white)
                    .font(.caption)
                }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
            )
        })
        .padding(.bottom, 20)
    }

    // MARK:
    var actionButton: some View {
        let buttonTitle = self.viewModel.isAttempted
        ? "Next"
        : "Skip"
        
        return PrimaryGradientButton(title: buttonTitle) {
            self.viewModel.didTapNext()
        }
    }
}

#Preview {
    QuizView()
}
