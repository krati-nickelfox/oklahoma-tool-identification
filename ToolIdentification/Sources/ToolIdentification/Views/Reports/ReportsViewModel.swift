//
//  File.swift
//  
//
//  Created by Chakshu Dawara on 22/02/24.
//

import Foundation

struct CategoryScore {
    let categoryName: String
    let score: Double
}

struct SubcategoryScore {
    let subcategoryName: String
    let score: Double
}

class ReportsViewModel: ObservableObject {
    
    @Published var categoriesWithScores: [CategoryScore] = []
    
    init() { }
    
    func fetchCategoriesWithScores() {
        if let categoriesWithScores = RealmManager.fetchCategoriesWithScores() {
            let sortedCategoriesWithScores = categoriesWithScores
                .map { CategoryScore(categoryName: $0.key, score: $0.value) }
                .sorted { $0.categoryName > $1.categoryName }
            
            self.categoriesWithScores = sortedCategoriesWithScores
        }
    }
    
}
