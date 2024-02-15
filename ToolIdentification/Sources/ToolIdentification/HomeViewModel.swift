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
    
    init() { }
    
    // Fetch categories to display in the alert
    func fetchCategories() {
        if let categoryNames = RealmManager.fetchCategories() {
            self.categoryNames = categoryNames
        }
    }
    
    func selectAllCategories() {
        self.selectedCategoryList = self.categoryNames
    }
}
