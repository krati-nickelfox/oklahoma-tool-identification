//
//  SubcategoryReportsViewModel.swift
//
//
//  Created by Chakshu Dawara on 26/02/24.
//

import Foundation

enum SubcategorySequenceType: String {
    case railCars = "Rail Cars"
    case tankTrucks = "Tank Trucks"
    case fixedFacility = "Fixed Facility"
    case nonbulk = "Nonbulk"
    case class1 = "Class 1"
    case class2 = "Class 2"
    case class3 = "Class 3"
    case class4 = "Class 4"
    case class5 = "Class 5"
    case class6 = "Class 6"
    case class7 = "Class 7"
    case class8 = "Class 8"
    case class9 = "Class 9"
    case npfa704 = "NFPA 704"
    
    // Define order for sorting
    static let sortOrderContainer: [SubcategorySequenceType] = [.railCars, .tankTrucks, .fixedFacility, .nonbulk]
    static let sortOrderPlacard: [SubcategorySequenceType] = [.class1, .class2, .class3, .class4, .class5, .class6, .class7, .class8, .class9, .npfa704]
    static let sortOrderBoth: [SubcategorySequenceType] = sortOrderContainer + sortOrderPlacard
}


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
            if self.selectedCategory == "Containers" {

                let filteredSubCategoriesWithScores = subcategoriesWithScores
                    .map { SubcategoryScore(subcategoryName: $0.0, score: $0.1) }
                    
                // Sort the filtered array based on the enum raw value
                let sortedSubCategoriesWithScores = filteredSubCategoriesWithScores.sorted {
                    SubcategorySequenceType.sortOrderContainer.firstIndex(of: $0.subcategoryEnumValue() )! < SubcategorySequenceType.sortOrderContainer.firstIndex(of: $1.subcategoryEnumValue())!
                }
                self.subcategoriesWithScores = sortedSubCategoriesWithScores
            } else {
                let sortedSubCategoriesWithScores = subcategoriesWithScores
                    .map { SubcategoryScore(subcategoryName: $0.0, score: $0.1) }
                    .sorted { $0.subcategoryName < $1.subcategoryName }
                
                self.subcategoriesWithScores = sortedSubCategoriesWithScores
            }
        }
    }
    
    func didTapSubcategoryCell() {
        ToolIdentification.quizManager?.selectedSubcategoryList = [self.selectedSubcategory]
    }
}
