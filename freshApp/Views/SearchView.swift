//
//  SearchView.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI
import AVKit

struct SearchView: View {
    
    @EnvironmentObject private var vm: SearchBar2Test
    @EnvironmentObject private var fb: FirebaseModel
    //let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!
    
    var body: some View {
        //        VStack {
        //            VideoPlayer(player: AVPlayer(url: url))
        //        }
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                TitleBarView(title: "Search Any Video")
                SearchBarView(textFieldText: $vm.AllVideosSearchText)
                Spacer()
                ScrollView {
                    ForEach(fb.posts) { video in
                        VideoView(post: video)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchBar2Test(post: Post(id: "id", image: nil, title: "something", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: [])))
            .environmentObject(FirebaseModel())
    }
}
