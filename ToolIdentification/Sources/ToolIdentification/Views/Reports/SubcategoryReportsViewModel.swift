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
        guard let subcategoriesWithScores = RealmManager.fetchSubcategoriesWithScores(for: self.selectedCategory) else { return }
        self.subcategoriesWithScores = subcategoriesWithScores.map {
            SubcategoryScore(
                subcategoryName: $0.key,
                score: $0.value
            )
        }
    }
    
    func didTapSubcategoryCell() {
        ToolIdentification.quizManager?.selectedSubcategoryList = [self.selectedSubcategory]
    }
}
