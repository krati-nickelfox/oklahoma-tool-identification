//
//  SubcategoryListViewModel.swift
//
//
//  Created by Chakshu Dawara on 14/02/24.
//

import Foundation

public class SubcategoryListViewModel: ObservableObject {
    
    @Published var selectedChapters: Set<Int> = []
    @Published var subcategoryNames: [String] = []
    @Published var selectedCategories: [String]
    
    init(selectedCategories: [String]) {
        self.selectedCategories = selectedCategories
    }
    
    func toggleSelection(for chapter: Int) {
        if selectedChapters.contains(chapter) {
            selectedChapters.remove(chapter)
        } else {
            selectedChapters.insert(chapter)
        }
    }
    
    // Fetching subcategories for the selected category on home
    func fetchAllSubcategories() {
        if let subcategories = RealmManager.fetchSubcategoryNames(forCategories: self.selectedCategories) {
            self.subcategoryNames = subcategories
        }
        print("Subcategories are: ", self.subcategoryNames)
    }
}
