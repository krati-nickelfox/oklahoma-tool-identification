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
    
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                headerView
                ScrollView(showsIndicators: false) {
                    subcategoriesProgressView
                }
            }
            if self.presentCalculationsView {
                    CustomBottomSheet(isSheetVisible: self.$presentCalculationsView, content: {
                        calculationsInfoView
                    }, leadingTrailingPadding: 20)
            }
        }
        .onAppear {
            self.viewModel.fetchSubcategoriesWithScores()
            self.orientation = UIDevice.current.orientation
        }
        .ignoresSafeArea()
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
        .background(
            NavigationLink(
                destination: destinationView(),
                isActive: self.$isNavigationLinkActive
            ) {
                EmptyView()
            }
        )
    }
    
    var headerView: some View {
        HeaderView(title: "\(self.viewModel.selectedCategory) Reports", leftButtonAction: {
            presentationMode.wrappedValue.dismiss()
        }, rightButtonAction: {
            withAnimation {
                self.presentCalculationsView = true
            }
        }, leftIconName: "back-icon", rightIconName: "info.circle.fill")
        .padding(.top, 44)
    }
    
    var subcategoriesProgressView: some View {
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
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(2)
                                
                                Text("\(formattedScore)%")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                                ProgressView(value: subcategoryWithScore.score / 100.0)
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .frame(width: self.isIPad ? (self.orientation.isLandscape ? 800 : 500) : 161, height: 10)
                                    .scaleEffect(x: 1, y: 2.5, anchor: .center)
                                    .tint(progressTint)
                            }
                            .padding(.horizontal, 16)
                        }
                        .background(LinearGradient(colors: [Color(red: 27/255, green: 24/255, blue: 25/255), Color(red: 35/255, green: 31/255, blue: 32/255)], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 50)
                    }
                    
                    
                }
            })
            .padding(.horizontal, 12)
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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: 20, height: 2)
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("How are results calculated?")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold))
                    
                    Text("This formula is used to calculate results:")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                    
                    HStack(alignment: .center) {
                        Text("Progress of a subcategory = ")
                            .padding(.top, 16)
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .bold))
                        
                        HStack(alignment: .center) {
                            VStack {
                                Text("Total number of correctly answered questions in the subcategory")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .bold))
                                    .multilineTextAlignment(.center)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.white)
                                
                                Text("Total number of questions in the subcategory")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .bold))
                                    .multilineTextAlignment(.center)
                            }
                            
                            Text("X 100")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                                .padding(.top, 16)
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray)
                    
                    Text("Please note that your last attempt on a question determines it's value in the calculation.")
                        .foregroundColor(.white)
                        .italic()
                    
                    Text("For eg: If Subcategory 1 has 100 questions and you answer Q1, Q2, Q3 correctly, you will see 3% progress in View Reports section. However, if you take another attempt and this time you answer Q1 incorrectly, your progress for Subcategory 1 will be reduced to 2%")
                        .foregroundColor(.white)
                        .italic()
                }
            }
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
    }
}
