//
//  HomeViewModel.swift
//
//
//  Created by Chakshu Dawara on 15/02/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var categoryNames: [String] = []
    @Published var selectedCategoryList: [String] = []
    
    var navigation: NavigationType = .quiz {
        didSet {
            self.fetchCategories()
        }
    }
    
    init() { }
    
    // Fetch categories to display in the alert
    func fetchCategories() {
        if self.navigation == .studyDeck {
            self.fetchCategoriesInStudyDeck()
        } else {
            if let categoryNames = RealmManager.fetchCategories() {
                self.categoryNames = categoryNames
            }
        }
    }
    
    private func fetchCategoriesInStudyDeck() {
        if let categoryNames = RealmManager.fetchCategoriesInStudyDeck() {
            self.categoryNames = categoryNames
        }
    }

    func selectAllCategories() {
        self.selectedCategoryList = self.categoryNames
    }
}
