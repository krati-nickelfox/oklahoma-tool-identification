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
                topHeaderView
                ScrollView(showsIndicators: false) {
                    listHeaderView
                    subcategoriesView
                }
                Spacer()
            }
            if self.viewModel.selectedChapters.count > 0 {
                VStack {
                    Spacer()
                    nextButtonView
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
                Button {
                    self.isCheckmarkNotVisible = false
                    self.viewModel.toggleSelection(for: index)
                } label: {
                    VStack(spacing: 12) {
                        HStack(alignment: .center, spacing: 12) {
                            
                            Image("practice-exam-icon")
                                .resizable()
                                .frame(width: 48, height: 48)
                            
                            Text(self.viewModel.subcategoryNames[index])
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Spacer()
                            
                            if !self.isCheckmarkNotVisible {
                                Image(self.viewModel.selectedChapters.contains(index) ? "checkmark-filled" : "checkmark-unfilled")
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(red: 82/255, green: 82/255, blue: 82/255))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
            }
        }
    }
    
    var nextButtonView: some View {
        Button {
            //
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 148, height: 48)
                    .foregroundColor(.yellow)
                
                Text("Next")
                    .foregroundColor(.black)
                    .bold()
            }
        }
        
    }
}
