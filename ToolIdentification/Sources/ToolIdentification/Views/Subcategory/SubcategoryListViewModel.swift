//
//  SubcategoryListViewModel.swift
//
//
//  Created by Chakshu Dawara on 14/02/24.
//

import Foundation

public class SubcategoryListViewModel: ObservableObject {
    
    @Published var selectedSubcategories: [String] = []
    @Published var subcategoryNames: [String] = []
    @Published var selectedCategories: [String]
    
    init(selectedCategories: [String]) {
        self.selectedCategories = selectedCategories
    }
    
    func toggleSelection(for subcategoryName: String) {
        if let index = self.selectedSubcategories.firstIndex(of: subcategoryName) {
            self.selectedSubcategories.remove(at: index)
        } else {
            self.selectedSubcategories.append(subcategoryName)
        }
        print("Toggle on Selection:::", self.selectedSubcategories)
    }
    
    func toggleSelectAll() {
        if self.selectedSubcategories.count == self.subcategoryNames.count {
            self.selectedSubcategories.removeAll()
        } else {
            self.selectedSubcategories = self.subcategoryNames
        }
        print("Toggle All:::", self.selectedSubcategories)
    }
    
    // Fetching subcategories for the selected category on home
    func fetchAllSubcategories() {
        if let subcategories = RealmManager.fetchSubcategoryNames(forCategories: self.selectedCategories) {
            self.subcategoryNames = subcategories
        }
        print("Subcategories are: ", self.subcategoryNames)
    }
    
    func didTapNextButton() {
        ToolIdentification.quizManager?.selectedSubcategoryList = self.selectedSubcategories
    }
}
