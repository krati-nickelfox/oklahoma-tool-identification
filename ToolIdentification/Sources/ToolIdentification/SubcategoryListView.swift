//
//  SubcategoryListView.swift
//
//
//  Created by Chakshu Dawara on 14/02/24.
//

import SwiftUI

public struct SubcategoryListView: View {
    
    @ObservedObject var viewModel = SubcategoryListViewModel()
    /// Below variable is to not show the checkmarks before the first interaction
    @State var isCheckmarkNotVisible = true
    /// Environment Variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    public init() { }
    
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
        }
        .background(Color(red: 35/255, green: 31/255, blue: 32/255))
        .ignoresSafeArea()
        .onAppear {
            self.viewModel.fetchAllSubcategories()
        }
    }
    
    // MARK: Header
    var topHeaderView: some View {
        HeaderView(title: "Placards",
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
            Text("52 sub-categories")
                .foregroundColor(.white)
                .font(.caption)
            
            Text("\(self.viewModel.selectedChapters.count) Selected")
                .foregroundColor(.white)
                .bold()
            
            Text("Select Module(s)")
                .foregroundColor(.yellow)
                .font(.caption)
                .onTapGesture {
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
                        .onTapGesture {
                            // Toggle the selection state of the chapter
                            self.isCheckmarkNotVisible = false
                            if self.viewModel.selectedChapters.contains(index) {
                                self.viewModel.selectedChapters.remove(index)
                            } else {
                                self.viewModel.selectedChapters.insert(index)
                            }
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
