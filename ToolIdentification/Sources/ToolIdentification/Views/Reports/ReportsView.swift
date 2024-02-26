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
    
    @StateObject var viewModel: SubcategoryReportsViewModel
    
    @State private var isNavigationLinkActive: Bool = false
    
    @State private var presentCalculationsView: Bool = false
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HeaderView(title: "\(self.viewModel.selectedCategory) Reports", leftButtonAction: {
                    presentationMode.wrappedValue.dismiss()
                }, rightButtonAction: {
                    self.presentCalculationsView = true
                }, leftIconName: "back-icon", rightIconName: "info.circle.fill")
                .padding(.top, 44)
                subcategoriesProgressView
            }
        }
        .onAppear {
            self.viewModel.fetchSubcategoriesWithScores()
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
        .background(
            NavigationLink(
                destination: destinationView(),
                isActive: self.$isNavigationLinkActive
            ) {
                EmptyView()
            }
        )
        .sheet(isPresented: self.$presentCalculationsView) {
            calculationsInfoView
        }
    }
    
    var subcategoriesProgressView: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 16, content: {
                ForEach(0..<self.viewModel.subcategoriesWithScores.count, id: \.self) { index in
                    let subcategoryWithScore = self.viewModel.subcategoriesWithScores[index]
                    let progressTint = self.progressTintColor(for: subcategoryWithScore.score)
                    let formattedScore = String(format: "%.2f", subcategoryWithScore.score)
                    Button {
                        self.viewModel.toggleSelection(for: subcategoryWithScore.subcategoryName)
                        print(self.viewModel.selectedSubcategory)
                        self.isNavigationLinkActive = true
                    } label: {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                            
                            HStack(alignment: .center, spacing: 16) {
                                Text(subcategoryWithScore.subcategoryName)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                Text("\(formattedScore)%")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                                ProgressView(value: subcategoryWithScore.score / 100.0)
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .frame(width: 161, height: 10)
                                    .scaleEffect(x: 1, y: 2.5, anchor: .center)
                                    .tint(progressTint)
                            }
                            .padding(.horizontal, 16)
                        }
                        .background(LinearGradient(colors: [Color(red: 27/255, green: 24/255, blue: 25/255), Color(red: 35/255, green: 31/255, blue: 32/255)], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 31)
                    }
                    
                    
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
        } else if score >= 70 && score <= 100 {
            return .green
        } else {
            return .white
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if let manager = ToolIdentification.quizManager {
            QuizView(viewModel: QuizViewModel(manager: manager, navigationType: .reports))
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Calculations view(To be displayed on tap of info button)
    var calculationsInfoView: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 24) {
                Text("How are results calculated?")
                    .foregroundColor(.white)
                
                Text("This formula is used to calculate results:")
                    .foregroundColor(.white)
                
                HStack(alignment: .center) {
                    Text("Progress of a subcategory = ")
                        .foregroundColor(.white)
                    
                    HStack(alignment: .center) {
                        VStack {
                            Text("Total number of correctly answered questions in the subcategory")
                                .foregroundColor(.white)
                            
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(.white)
                            
                            Text("Total number of questions in the subcategory")
                                .foregroundColor(.white)
                        }
                        
                        Text("X 100")
                            .foregroundColor(.white)
                    }
                }
                
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(.gray)
                
                Text("Please note that your last attempt on a question determines it's value in the calculation.")
                    .foregroundColor(.white)
                
                Text("For eg: If Subcategory 1 has 100 questions and you answer Q1, Q2, Q3 correctly, you will see 3% progress in View Reports section. However, if you take another attempt and this time you answer Q1 incorrectly, your progress for Subcategory 1 will be reduced to 2%")
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
    }
}
