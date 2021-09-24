//
//  TrendingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct TrendingView: View {
    
    @State var selection: String? = ""
    @State var profileView = "profileView"
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TitleBarView(title: "Trending")
                ScrollView {
                    ForEach(fb.posts) { post in
                        HStack {
                            Image(uiImage: post.image!)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            Text(post.caption)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
            .environmentObject(FirebaseModel())
    }
}
