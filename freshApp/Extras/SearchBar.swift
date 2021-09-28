//
//  SearchBar.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/28/21.
//

import SwiftUI
import Combine

class SearchBar: ObservableObject {
    
    @Published var searchText = ""
    
    @Published var allData: [SubjectsModel]
    var filteredData: [SubjectsModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        self.allData = Bundle.main.decode([SubjectsModel].self, from: "subjects.json")
        self.filteredData = allData
        addSubscriber()
                
    }
    
    func addSubscriber() {
        $searchText
            .combineLatest($allData)
            .map { (text, subjects) -> [SubjectsModel] in
                guard !text.isEmpty else {
                    return subjects
                }
                
                let lowercasedText = text.lowercased()
                
                return subjects.filter { user in
                    return user.name.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] returnedSubjects in
                self?.filteredData = returnedSubjects
            }
            .store(in: &cancellables)
    }
    
}
