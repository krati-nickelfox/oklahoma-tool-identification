//
//  QuizView.swift
//
//
//  Created by Krati Mittal on 13/02/24.
//

import SwiftUI

public struct QuizView: View {
        
    enum Optionstate {
        case none
        case correct
        case incorrect
        
        var color: Color {
            switch self {
            case .none:
                Color(red: 0.26, green: 0.26, blue: 0.25)
            case .correct:
                Color(red: 0.37, green: 0.81, blue: 0.49)
            case .incorrect:
                Color(red: 0.86, green: 0.39, blue: 0.31)
            }
        }
        
        var image: String {
            switch self {
            case .correct: "TickMarkIcon"
            case .incorrect: "CrossMarkIcon"
            case .none: ""
            }
        }
    }
    
    public init() {}
    
    @State var optionState: Optionstate = .incorrect
    @State var isAddedToStudyDeck = false

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
                    Text("Question 1 of 65")
                        .foregroundStyle(Color(red: 0.96, green: 0.75, blue: 0.015))

                    Spacer()
                    
                    Text("C.1 - sc.3 - q.2")
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
                                        
                                        Text("IFSTA")
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
                        Text("What is the label's name displayed in the top right corner of the fire extinguisher in the provided image?")
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .padding(.bottom, 16)
                        
                        Button(action: {
                            
                        }, label: {
                            Color.init(red: 0.96,
                                       green: 0.75,
                                       blue: 0.015)
                            .clipShape(.rect(cornerRadius: 4))
                            .frame(width: UIScreen.main.bounds.width * 0.35)
                            .frame(height: 28)
                            .overlay(
                                HStack(spacing: 6) {
                                    Rectangle()
                                        .fill(self.isAddedToStudyDeck
                                              ? .white
                                              : .clear)
                                        .frame(width: 15, height: 15)
                                        .border(.white)
                                        .overlay {
                                            if self.isAddedToStudyDeck {
                                                Image("TickMarkIcon", bundle: .module)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 15, height: 15)
                                            }
                                        }
                                    Text(self.isAddedToStudyDeck
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
                            ForEach(0..<4) { index in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(self.optionState.color)
                                    .frame(minHeight: 48)
                                    .overlay {
                                        HStack(spacing: 10) {
                                            Text("Option \(index)")
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(2)
                                            
                                            //
                                            if self.optionState != .none {
                                                Spacer()
                                                
                                                Circle()
                                                    .fill(self.optionState.color.opacity(0.4))
                                                    .frame(width: 24, height: 24)
                                                    .overlay {
                                                        Image(self.optionState.image, bundle: .module)
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
                                                gradient: Gradient(colors: [.white,
                                                                            .gray.opacity(0.6)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ), lineWidth: 0.75)
                                    }
                                    .padding(.horizontal, 1)
                                    .shadow(color: .white.opacity(0.08), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
                                    .onTapGesture {
                                        self.optionState = .correct
                                    }

                            }
                        }
                    }
                    Spacer(minLength: 48)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            ///
            Button(action: {
                
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
                    Text("Next")
                        .foregroundColor(.black)
                )
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.58), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 4)
            })
        }
    }
}

#Preview {
    QuizView()
}
