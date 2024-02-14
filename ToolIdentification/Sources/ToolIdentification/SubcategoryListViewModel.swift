//
//  SubcategoryListViewModel.swift
//
//
//  Created by Chakshu Dawara on 14/02/24.
//

import Foundation

class SubcategoryListViewModel: ObservableObject {
    
    @Published var selectedChapters: Set<Int> = []
    
    init() { }
    
    func toggleSelection(for chapter: Int) {
        if selectedChapters.contains(chapter) {
            selectedChapters.remove(chapter)
        } else {
            selectedChapters.insert(chapter)
        }
    }
}
