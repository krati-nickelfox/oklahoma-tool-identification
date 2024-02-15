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
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var selectModuleText: String {
        if self.viewModel.selectedChapters.count == self.viewModel.subcategoryNames.count && self.viewModel.selectedChapters.count > 0 {
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
                self.topHeaderView
                
                ScrollView(showsIndicators: false) {
                    self.listHeaderView
                    self.subcategoriesView
                }
            }
            
            if self.viewModel.selectedChapters.count > 0 {
                VStack {
                    Spacer()
                    
                    NavigationLink {
                        QuizView()
                    } label: {
                        PrimaryGradientButton(title: "Next") {}
                            .disabled(true) // disabled button for the navigation link to work
                    }

                }
                .padding(.bottom, 60)
            }
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
        .ignoresSafeArea()
        .onAppear {
            self.viewModel.fetchAllSubcategories()
        }
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
        HStack(spacing: 24) {
            Text("\(self.viewModel.subcategoryNames.count) sub-categories")
                .foregroundColor(.white)
                .font(.caption)
            
            Text("\(self.viewModel.selectedChapters.count) Selected")
                .foregroundColor(.white)
                .bold()
            
            Text(self.selectModuleText)
                .foregroundColor(.yellow)
                .font(.caption)
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
                                Image(self.viewModel.selectedChapters.contains(index)
                                      ? "checkmark-filled"
                                      : "checkmark-unfilled",
                                      bundle: .module)
                            }
                        }
                        .onTapGesture {
                            // Toggle the selection state of the chapter
                            self.isCheckmarkNotVisible = false
                            self.viewModel.toggleSelection(for: index)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(red: 82/255, green: 82/255, blue: 82/255))
                    }
                    .padding(.horizontal, 20)
                }
        }
    }
}
