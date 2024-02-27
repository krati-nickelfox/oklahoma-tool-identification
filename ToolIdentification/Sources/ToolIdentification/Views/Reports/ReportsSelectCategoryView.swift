//
//  ReportsSelectCategoryView.swift
//
//
//  Created by Chakshu Dawara on 22/02/24.
//

import SwiftUI

public struct ReportsSelectCategoryView: View {
    
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: ReportsViewModel
    
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HeaderView(title: "View Reports", leftButtonAction: {
                    presentationMode.wrappedValue.dismiss()
                }, rightButtonAction: nil, leftIconName: "back-icon", rightIconName: nil)
                .padding(.top, 44)
                ScrollView {
                    VStack(spacing: 40) {
                        selectCategoryTitleView
                        categoriesView
                    }
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
        .onAppear {
            self.viewModel.fetchCategoriesWithScores()
        }
    }
    
    var selectCategoryTitleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Select Category")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Please select any one of the following:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var categoriesView: some View {
        VStack(spacing: 20, content: {
            ForEach(0..<self.viewModel.categoriesWithScores.count, id: \.self) { index in
                let categoryWithScore = self.viewModel.categoriesWithScores[index]
                let progressTint = self.progressTintColor(for: categoryWithScore.score)
                let formattedScore = String(format: "%.2f", categoryWithScore.score)
                let categoryName = categoryWithScore.categoryName
                let categoryImage = categoryName == "Placards" ? ImageResource.placardIcon : ImageResource.containersIcon
                Button(action: { }, label: {
                    NavigationLink {
                        ReportsView(viewModel: SubcategoryReportsViewModel(selectedCategory: categoryName))
                            .navigationBarBackButtonHidden()
                    } label: {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 8)
                            
                            HStack(alignment: .center, spacing: 16, content: {
                                
                                Image(categoryImage)
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                
                                Text(categoryName)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 4, content: {
                                    HStack(spacing: 0, content: {
                                        Text("Score: ")
                                            .foregroundColor(.gray)
                                        
                                        Text("\(formattedScore)%")
                                            .foregroundColor(progressTint)
                                    })
                                    
                                    ProgressView(value: categoryWithScore.score / 100.0)
                                        .progressViewStyle(LinearProgressViewStyle())
                                        .tint(progressTint)
                                        .background(.black)
                                        .cornerRadius(3.0)
                                })
                                .frame(width: 120)
                            })
                            .padding(.horizontal, 20)
                        }
                        .frame(height: 72)
                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                    }

                })
            }
        })
        .padding(.horizontal, 18)
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
}
