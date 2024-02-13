//  HomeView.swift
//  OklahomaToolIdentification
//
//  Created by Krati Mittal on 11/01/24.
//

import SwiftUI

public enum NavigationType {
    case practiceExam
    case studyDeck
    case reports
}

public struct HomeView: View {
    
    let backgroundImageName: String
    let appLogoName: String
    
    public init(
        backgroundImageName: String,
        appLogoName: String
    ) {
        self.backgroundImageName = backgroundImageName
        self.appLogoName = appLogoName
    }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            /// Dynamic background image
            backgroundImageView
            blackGradientView
            /// To manage the content over the image
            VStack(alignment: .center, spacing: 37) {
                topAppLogoView
                identifyTitleView
                Spacer()
                centerTileVew
                Spacer()
            }
        }
        .background(.black)
    }
    
    // MARK: Background Image
    var backgroundImageView: some View {
        Image(self.backgroundImageName)
            .resizable()
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: Black Gradient
    var blackGradientView: some View {
        VStack {
            LinearGradient(
                colors: [
                    .black,
                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: UIScreen.main.bounds.height/1.2)
            
            Spacer()
        }
    }
    
    // MARK: App Logo
    var topAppLogoView: some View {
        Image(self.appLogoName)
            .padding(.top, 30)
    }
    
    // MARK: Title
    var identifyTitleView: some View {
        VStack(spacing: 12) {
            Text("Identify")
                .font(.custom("Helvetica Neue Medium", size: 36))
                .foregroundColor(.white)
            
            RoundedRectangle(cornerRadius: 4)
                .frame(
                    width: 35,
                    height: 4
                )
                .foregroundColor(.white)
        }
    }
    
    // MARK: Center Tiles
    // Start Practice, Study Deck and Reports
    var centerTileVew: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                // Start Practice
                Button { } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                .gray,
                                lineWidth: 2
                            )
                            .background(.black.opacity(0.11))
                            .frame(height: 120)
                            .padding(
                                .horizontal,
                                24
                            )
                        
                        VStack(spacing: 8, content: {
                            Image("practice-exam")
                                .frame(
                                    width: 24,
                                    height: 24
                                )
                            
                            Text("Start Practice")
                            // FIXME: Font to be updated below with Lato
                                .font(.custom("Helvetica Neue Medium", size: 16))
                                .foregroundColor(.white)
                        })
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                HStack(spacing: 11) {
                    // Study Deck
                    Button {
                        if let studyDeckQuestions = RealmManager.fetchStudyDeckQuestions(), !studyDeckQuestions.isEmpty {
                            print("Navigating to Study Deck View")
                        } else {
                            print("No questions found in study deck")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    .gray,
                                    lineWidth: 2
                                )
                                .background(.black.opacity(0.11))
                                .frame(height: 120)
                            
                            VStack(spacing: 8, content: {
                                Image("study-deck")
                                    .frame(
                                        width: 24,
                                        height: 24
                                    )
                                
                                Text("Review My Study Deck")
                                    // FIXME: Font to be updated below with Lato
                                    .font(.custom("Helvetica Neue Medium", size: 16))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            })
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // View Reports
                    Button { } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    .gray,
                                    lineWidth: 2
                                )
                                .background(.black.opacity(0.11))
                                .frame(height: 120)
                            
                            VStack(spacing: 8, content: {
                                Image("reports")
                                    .frame(
                                        width: 24,
                                        height: 24
                                    )
                                
                                Text("View Reports")
                                // FIXME: Font to be updated below with Lato
                                    .font(.custom("Helvetica Neue Medium", size: 16))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            })
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: geometry.size.width)
            }
            .frame(maxWidth: geometry.size.width)
        }
    }
}
