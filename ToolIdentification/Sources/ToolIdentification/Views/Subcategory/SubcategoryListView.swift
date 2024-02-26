//
//  SubcategoryListView.swift
//
//
//  Created by Chakshu Dawara on 14/02/24.
//

import SwiftUI

public struct SubcategoryListView: View {
    
    @ObservedObject var viewModel: SubcategoryListViewModel
    /// Below variable is to not show the checkmarks before the first interaction
    @State var isCheckmarkNotVisible = true
    ///
    @State var presentQuizView = false
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var selectModuleText: String {
        if self.viewModel.selectedSubcategories.count == self.viewModel.subcategoryNames.count && self.viewModel.selectedSubcategories.count > 0 {
            return "Unselect All"
        } else {
            return self.isCheckmarkNotVisible ? "Select Module(s)" : "Select All"
        }
    }
    
    public init(viewModel: SubcategoryListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                topHeaderView
                ScrollView(showsIndicators: false) {
                    listHeaderView
                    subcategoriesView
                }
                
                if viewModel.selectedSubcategories.count > 0 {
                    Spacer()
                    if let manager = ToolIdentification.quizManager {
                        
                        NavigationLink(
                            destination: QuizView(viewModel: QuizViewModel(manager: manager, navigationType: self.viewModel.navigation)),
                            isActive: self.$presentQuizView
                        ) {
                            EmptyView()
                        }
                    }
                }
            }
            if self.viewModel.selectedSubcategories.count > 0 {
                VStack {
                    Spacer()
                    PrimaryGradientButton(title: "Next") {
                        self.viewModel.didTapNextButton()
                        self.presentQuizView = true
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .ignoresSafeArea()
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
        .onAppear {
            self.viewModel.fetchAllSubcategories()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: Header
    var topHeaderView: some View {
        HeaderView(title: self.viewModel.selectedCategories.joined(separator: "/ "),
                   leftButtonAction: {
            presentationMode.wrappedValue.dismiss()
        },
                   rightButtonAction: nil,
                   leftIconName: "back-icon",
                   rightIconName: nil)
        .padding(.top, 44)
    }
    
    // MARK: List Header
    var listHeaderView: some View {
        HStack {
            Text("\(self.viewModel.subcategoryNames.count) sub-categories")
                .foregroundColor(.white)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(self.viewModel.selectedSubcategories.count) Selected")
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(self.selectModuleText)
                .foregroundColor(.yellow)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    self.viewModel.toggleSelectAll()
                    self.isCheckmarkNotVisible = false
                }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: Subcategories listing
    var subcategoriesView: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(self.viewModel.subcategoryNames.indices, id: \.self) { index in
                Button {
                    self.isCheckmarkNotVisible = false
                    self.viewModel.toggleSelection(for: self.viewModel.subcategoryNames[index])
                } label: {
                    VStack(spacing: 12) {
                        HStack(alignment: .center, spacing: 12) {
                            
                            Image("practice-exam-icon", bundle: .module)
                                .resizable()
                                .frame(width: 48, height: 48)
                            
                            Text(self.viewModel.subcategoryNames[index])
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Spacer()
                            
                            if !self.isCheckmarkNotVisible {
                                Image(self.viewModel.selectedSubcategories.contains(self.viewModel.subcategoryNames[index])
                                      ? "checkmark-filled"
                                      : "checkmark-unfilled",
                                      bundle: .module)
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(red: 82/255, green: 82/255, blue: 82/255))
                    }
                    .padding(.horizontal, 20)
                }
                .contentShape(Rectangle())
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    self.isCheckmarkNotVisible = false
                    self.viewModel.toggleSelection(for: self.viewModel.subcategoryNames[index])
                }
            }
        }
    }
}
