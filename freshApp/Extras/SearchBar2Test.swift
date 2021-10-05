//
//  SearchBar2Test.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI
import Combine

class SearchBar2Test: ObservableObject {
    
    @Published var AllVideosSearchText = ""
    @Published var allVideos: [Post]
    var filteredVideos: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        // The problem is that this is getting inited only one time. Posts is empty before we load.
        self.allVideos = []
        self.filteredVideos = allVideos
        addSubscriberToAllVideos()
    }
    
    
    func addSubscriberToAllVideos() {
        
        $AllVideosSearchText
            .combineLatest($allVideos)
            .map { (text, posts) -> [Post] in
                guard !text.isEmpty else {
                    return posts
                }
                let lowercasedText = text.lowercased()
                
                return posts.filter { post in
                    return
                        post.title.lowercased().contains(lowercasedText) ||
                        post.user.username.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] returnedPosts in
                self?.filteredVideos = returnedPosts
            }
            .store(in: &cancellables)
        
        
//            .map { (text, subjects) -> [SubjectsModel] in
//                guard !text.isEmpty else {
//                    return subjects
//                }
//
//                let lowercasedText = text.lowercased()
//
//                return subjects.filter { user in
//                    return user.name.lowercased().contains(lowercasedText)
//                }
//            }
//            .sink { [weak self] returnedSubjects in
//                self?.filteredData = returnedSubjects
//            }
//            .store(in: &cancellables)
        
    }
}
