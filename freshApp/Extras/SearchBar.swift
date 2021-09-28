//
//  SearchBar.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/27/21.
//

import SwiftUI
import Combine

class SearchBar: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var subjects: [SubjectsModel] = Bundle.main.decode([SubjectsModel].self, from: "subjects.json")

    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        
        $searchText
            .combineLatest($subjects)
            .map { (text, subjects) -> [SubjectsModel] in
                guard !text.isEmpty else {
                    return subjects
                }
                let lowercasedText = text.lowercased()
                
                return subjects.filter { (user) in
                    return user.name.lowercased().contains(lowercasedText)
                }
                
            }
            .sink { [weak self] returnedSubjects in
                self?.subjects = returnedSubjects
            }
            .store(in: &cancellables)
    }
    
}
