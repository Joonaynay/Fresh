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
    @Published var searchButton: Bool = false
    var filteredVideos: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
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
                if self?.searchButton == true {
                    self?.filteredVideos = returnedPosts
                }
            }
            .store(in: &cancellables)
            
    }
}
