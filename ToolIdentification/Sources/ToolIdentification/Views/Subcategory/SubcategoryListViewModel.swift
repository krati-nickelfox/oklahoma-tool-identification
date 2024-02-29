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
    
    ///
    var navigation: NavigationType
    private let manager: QuizManager?

    init(manager: QuizManager?,
         selectedCategories: [String],
         navigation: NavigationType) {
        self.selectedCategories = selectedCategories
        self.navigation = navigation
        self.manager = manager
    }
    
    func toggleSelection(for subcategoryName: String) {
        if let index = self.selectedSubcategories.firstIndex(of: subcategoryName) {
            self.selectedSubcategories.remove(at: index)
        } else {
            self.selectedSubcategories.append(subcategoryName)
        }
    }
    
    func toggleSelectAll() {
        if self.selectedSubcategories.count == self.subcategoryNames.count {
            self.selectedSubcategories.removeAll()
        } else {
            self.selectedSubcategories = self.subcategoryNames
        }
    }
    
    // Fetching subcategories for the selected category on home
    func fetchAllSubcategories() {
        if self.navigation == .studyDeck {
            self.fetchAllSubcategoriesInStudyDeck()
        } else {
            if var subcategories = RealmManager.fetchSubcategoryNames(forCategories: self.selectedCategories) {

               subcategories.sort { (str1, str2) in
                    guard let index1 = SubcategorySequenceType.sortOrderBoth.firstIndex(of: SubcategorySequenceType(rawValue: str1) ?? .railCars ),
                          let index2 = SubcategorySequenceType.sortOrderBoth.firstIndex(of: SubcategorySequenceType(rawValue: str2) ?? .railCars ) else {
                        return false // Return false if one of the elements is not found in the sortOrder
                    }
                    return index1 < index2
                }
                self.subcategoryNames = subcategories
                }
                
            }
    }
    
    func fetchAllSubcategoriesInStudyDeck() {
        let selectedCategoryList = self.selectedCategories
        if var subcategories = RealmManager.fetchSubcategoriesInStudyDeckFor(selectedCategoryList) {
            subcategories.sort { (str1, str2) in
                guard let index1 = SubcategorySequenceType.sortOrderBoth.firstIndex(of: SubcategorySequenceType(rawValue: str1) ?? .railCars ),
                      let index2 = SubcategorySequenceType.sortOrderBoth.firstIndex(of: SubcategorySequenceType(rawValue: str2) ?? .railCars ) else {
                    return false // Return false if one of the elements is not found in the sortOrder
                }
                return index1 < index2
            }
            self.subcategoryNames = subcategories
        }
    }
    
    func didTapNextButton() {
        ToolIdentification.quizManager?.selectedSubcategoryList = self.selectedSubcategories
    }
}
