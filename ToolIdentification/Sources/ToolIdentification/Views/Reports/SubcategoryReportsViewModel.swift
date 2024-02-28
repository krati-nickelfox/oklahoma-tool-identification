//
//  SubcategoryReportsViewModel.swift
//
//
//  Created by Chakshu Dawara on 26/02/24.
//

import Foundation

class SubcategoryReportsViewModel: ObservableObject {
    
    @Published var subcategoriesWithScores: [SubcategoryScore] = []
    @Published var selectedCategory: String
    @Published var selectedSubcategory: String = ""
    
    init(selectedCategory: String) {
        self.selectedCategory = selectedCategory
    }
    
    func toggleSelection(for subcategoryName: String) {
        self.selectedSubcategory = subcategoryName
        self.didTapSubcategoryCell()
    }
    
    func fetchSubcategoriesWithScores() {
        if let subcategoriesWithScores = RealmManager.fetchSubcategoriesWithScores(for: self.selectedCategory) {
            let sortedSubCategoriesWithScores = subcategoriesWithScores
                .map { SubcategoryScore(subcategoryName: $0.0, score: $0.1) }
                .sorted { $0.subcategoryName < $1.subcategoryName }
            
            self.subcategoriesWithScores = sortedSubCategoriesWithScores
        }
    }
    
    func didTapSubcategoryCell() {
        ToolIdentification.quizManager?.selectedSubcategoryList = [self.selectedSubcategory]
    }
}
