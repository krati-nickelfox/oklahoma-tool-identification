//
//  QuizView.swift
//
//
//  Created by Krati Mittal on 13/02/24.
//

import SwiftUI

enum QuizViewType {
    case quiz
    case result
    
    var title: String {
        switch self {
        case .quiz:
            "Tool Identification"
        case .result:
            "Result"
        }
    }
    
    var leftButtonIcon: String? {
        switch self {
        case .quiz:
            "back-icon"
        case .result:
            nil
        }
    }

    var rightButtonIcon: String? {
        "ExitIcon"
    }
}

struct QuizView: View {
    
    @StateObject var viewModel: QuizViewModel
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    ///
    @State var viewType: QuizViewType = .quiz
    @State var exitQuiz: Bool = false
    @State var showExitConfirmationAlert: Bool = false
    @State var showScoreAndExitAlert: Bool = false

    
    var body: some View {
        ZStack(alignment: self.viewModel.isQuizLoaded
               ? .bottom
               : .center) {
            /// Background
            Color(red: 0.137, green: 0.121, blue: 0.125)
                .ignoresSafeArea()

            if self.viewModel.isQuizLoaded {
                VStack {
                    /// Header View
                    self.topHeaderView
                        .padding(.bottom, 24)
                    
                    if self.viewType == .quiz {
                        self.questionCountDetailView
                        
                        self.optionListView
                            .padding(.horizontal, 20)
                    } else { // Reached quiz end, show result view
                        ResultView(viewModel: self.viewModel)
                    }
                }
                .padding(.bottom, 16)
                .ignoresSafeArea(edges: .bottom)
                
                if self.viewType == .quiz {
                    /// Next Button
                    self.actionButton
                }
            }
            
            if !self.viewModel.isQuizLoaded {
                ProgressView()
                    .tint(.white)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.viewModel.fetchQuestions()
//            }
        }
        .onReceive(self.viewModel.$quizEndAlertType) { alertType in
            self.showExitConfirmationAlert = alertType == .quizExitConfirmation
            self.showScoreAndExitAlert = alertType == .scoreAndExit
        }
        .alert("Exit", isPresented: self.$showScoreAndExitAlert) {
            VStack {
                Button {
                    self.viewType = .result
                } label: {
                    Text("Score and Exit")
                }
                
                Button(role: .destructive) {
                    self.navigateToHome()
                } label: {
                    Text("Exit without Score")
                        .tint(Color.red)
                }
            }
        }
        .alert(isPresented: self.$showExitConfirmationAlert) {
            Alert(title: Text("Exit"),
                  message: Text("Are you sure you want to exit?"),
                  primaryButton: .default(
                    Text("Cancel")),
                  secondaryButton: .destructive(
                    Text("Yes"),
                    action: {
                        self.navigateToHome()
                    }
                  )
            )
        }
    }
    
    // MARK: Header View
    var topHeaderView: some View {
        HeaderView(title: self.viewType.title,
                   leftButtonAction: nil,
                   rightButtonAction: {
            // Exit button action
            if self.viewType == .quiz {
                self.viewModel.didTapExit()
            } else {
                self.dismiss()
            }
        },
                   leftIconName: nil,
                   rightIconName: self.viewType.rightButtonIcon)
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
    
    // MARK: Possible Answers list View
    var optionListView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                /// Tool Image
                self.toolImageView
                
                /// Tool Description
                HStack {
                    Text(self.viewModel.activeQuestionDescription)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.bottom, 16)
                    
                    Spacer()
                }
                
                if self.viewModel.isAttempted {
                    /// Add To Study Deck
                    self.addToStudyDeckButtonView
                }
                
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
    
    // MARK: Tool Image View
    var toolImageView: some View {
        ZStack {
            Group {
                if let image = ImageManager.shared.getImageWithName(self.viewModel.activeQuestionImageId) {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    Image(systemName: "photo.artframe")
                        .resizable()
                }
            }
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
    
    // MARK: Add to Study Deck View
    var addToStudyDeckButtonView: some View {
        Button(action: {
            self.viewModel.didTapStudyDeckButton()
        }, label: {
            Color.init(red: 0.96,
                       green: 0.75,
                       blue: 0.015)
            .clipShape(.rect(cornerRadius: 4))
            .frame(width: 170)
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

    // MARK: Button View
    var actionButton: some View {
        let buttonTitle = self.viewModel.isAttempted
        ? (self.viewModel.isLastQuestion ? "Check Results" : "Next")
        : "Skip"
        
        return PrimaryGradientButton(title: buttonTitle) {
            self.viewModel.didTapNext()
        }
    }
    
    // MARK: Navigate To Previous Screen
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: Navigate To Home
    func navigateToHome() {
        NotificationCenter.default.post(name: Notification.Name("popToRootView"), object: nil)
    }
}
