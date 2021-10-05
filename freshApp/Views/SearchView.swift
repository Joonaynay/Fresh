//
//  SearchView.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI
import AVKit

struct SearchView: View {
    
    @State private var textFieldText: String = ""
    
    let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!
    
    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "train", ofType: ".mp4")!)))
            //VideoPlayer(player: AVPlayer(url: url))
        }
//        ZStack {
//            Color.theme.background
//                .ignoresSafeArea()
//            VStack {
//                TitleBarView(title: "Search Any Video")
//                SearchBarView(textFieldText: $textFieldText)
//                Spacer()
//
//            }
//        }
//        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
