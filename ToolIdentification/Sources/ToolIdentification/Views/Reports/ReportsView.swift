//
//  ReportsView.swift
//
//
//  Created by Chakshu Dawara on 22/02/24.
//

import SwiftUI

public struct ReportsView: View {
    
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel = ReportsViewModel()
    
    public init() { }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack {
                HeaderView(title: "\(self.viewModel.selectedCategory) Reports", leftButtonAction: {
                    presentationMode.wrappedValue.dismiss()
                }, rightButtonAction: {}, leftIconName: "back-icon", rightIconName: "ExitIcon")
                subcategoriesProgressView
            }
        }
        .onAppear {
            self.viewModel.fetchSubcategoriesWithScores()
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
    }
    
    var subcategoriesProgressView: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 16, content: {
                ForEach(0..<self.viewModel.subcategoriesWithScores.count, id: \.self) { index in
                    let subcategoryWithScore = self.viewModel.subcategoriesWithScores[index]
                    let progressTint = self.progressTintColor(for: subcategoryWithScore.score)
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 1)
                        
                        HStack(spacing: 16) {
                            Text(subcategoryWithScore.subcategoryName)
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Text("\(subcategoryWithScore.score)%")
                                .font(.caption)
                                .foregroundColor(progressTint)
                            
                            ProgressView(value: subcategoryWithScore.score)
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(height: 10)
                                .scaleEffect(x: 1, y: 2.5, anchor: .center)
                                .tint(progressTint)
                        }
                        .padding(.horizontal, 16)
                    }
                    .background(LinearGradient(colors: [Color(red: 27/255, green: 24/255, blue: 25/255), Color(red: 35/255, green: 31/255, blue: 32/255)], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 31)
                }
            })
            .padding(.horizontal, 12)
        })
    }
    
    // Progress bar tint color as per the percentage
    /// 0 - 49.9% Red
    /// 50 - 69.9% Yellow
    /// 70 - 100% Green
    func progressTintColor(for score: Double) -> Color {
        if score > 0 && score < 50 {
            return .red
        } else if score >= 50 && score < 70 {
            return .yellow
        } else {
            return .green
        }
    }
}
