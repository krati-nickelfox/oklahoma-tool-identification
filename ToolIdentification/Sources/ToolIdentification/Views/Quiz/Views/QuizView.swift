//
//  QuizView.swift
//
//
//  Created by Krati Mittal on 13/02/24.
//

import SwiftUI

public struct QuizView: View {
    
    public init?() {
        guard let manager = ToolIdentification.quizManager else {
            return nil
        }
        self.viewModel = QuizViewModel(manager: manager)
    }

    @ObservedObject var viewModel: QuizViewModel
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            /// Background
            Color(red: 0.15, green: 0.14, blue: 0.14)
                .ignoresSafeArea()

            VStack {
                /// Header View
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("Back")
                            .foregroundStyle(.white)
                    })
                    
                    Text("Tool Identification")
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Exit")
                            .foregroundStyle(.white)
                    })
                }
                .padding(.bottom, 24)
                
                HStack {
                    Text("Question \(self.viewModel.currentQuestionNumber) of \(self.viewModel.totalQuestionCount)")
                        .foregroundStyle(Color(red: 0.96, green: 0.75, blue: 0.015))

                    Spacer()
                    
                    Text(self.viewModel.activeQuestionId)
                        .foregroundStyle(Color(red: 0.63, green: 0.63, blue: 0.63))
                }
                .padding(.bottom, 12)
                .frame(height: 17)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        /// Tool Image
                        ZStack {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .clipShape(.rect(cornerRadius: 12))
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    HStack(spacing: 7) {
                                        Image(systemName: "photo.artframe")
                                            .resizable()
                                            .frame(width: 22, height: 18)
                                            .foregroundStyle(.gray)
                                        
                                        Text(self.viewModel.activeQuestionImageCurtsy)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                                .frame(height: 24)
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
                        
                        /// Tool Description
                        Text(self.viewModel.activeQuestionDescription)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .padding(.bottom, 16)
                        
                        Button(action: {
                            // self.isAddedToStudyDeck.toggle()
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
                        
                        /// Options list
                        VStack(spacing: 20) {
                            ForEach(0..<self.viewModel.activeQuestionOptionList.count,
                                    id: \.self) { index in
                                let (option, optionState) = self.viewModel.activeQuestionOptionList[index]
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(optionState.color)
                                    .frame(minHeight: 48)
                                    .overlay {
                                        HStack(spacing: 10) {
                                            Text(option.title)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(2)
                                            
                                            Spacer()

                                            if optionState != .none {
                                                Circle()
                                                    .fill(optionState.color.opacity(0.4))
                                                    .frame(width: 24, height: 24)
                                                    .overlay {
                                                        Image(optionState.image, bundle: .module)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .padding(5)
                                                    }
                                            }
                                        }
                                        .frame(alignment: .leading)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 20)
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(LinearGradient(
                                                gradient: Gradient(colors: [.white, .gray.opacity(0.6)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ), lineWidth: 0.75)
                                    }
                                    .padding(.horizontal, 1)
                                    .shadow(color: .white.opacity(0.08), radius: 10, x: 0, y: 4)
                                    .onTapGesture {
                                        self.viewModel.didSelectOption(index)
                                    }
                            }
                        }

                    }
                    Spacer(minLength: 48)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            /// Next Button
            Button(action: {
                self.viewModel.didTapNext()
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
                    Text(self.viewModel.isAttempted
                         ? "Next"
                         : "Skip")
                        .foregroundColor(.black)
                )
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.58), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
            })
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.viewModel.fetchQuestions()
            }
        }
    }
}

#Preview {
    QuizView()
}
