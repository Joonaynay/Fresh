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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
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
