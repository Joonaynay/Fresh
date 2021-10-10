//
//  SearchView.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var vm: SearchBar2Test
    @EnvironmentObject private var fb: FirebaseModel
    
    @State var searchResults: [Post]?
    
    @State private var searchText = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                TitleBarView(title: "Search")
                HStack {
                    SearchBarView(textFieldText: $searchText)
                    Button("Search") {
                        fb.search(string: searchText) { posts in
                            searchResults = posts
                        }
                    }.padding(.trailing)
                }
                if fb.loading {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                Spacer()
                ScrollView {
                    if let results = searchResults {
                        ForEach(results) { post in
                            PostView(post: post)
                        }
                    }
                }
            }
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        
        .onAppear {
            vm.allVideos = fb.posts
        }
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(FirebaseModel())
    }
}
