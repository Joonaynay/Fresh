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
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                TitleBarView(title: "Search")
                SearchBarView(textFieldText: $vm.AllVideosSearchText)
                Spacer()
                ScrollView {
                    ForEach(vm.filteredVideos) { video in
                        if !vm.AllVideosSearchText.isEmpty {
                            PostView(post: video)
                        }
                    }
                }
            }
        }
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
