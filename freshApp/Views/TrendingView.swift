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
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                TitleBarView(title: "Trending")
                ScrollView {
                        VStack {
                            ForEach(fb.posts) { post in
                                Image(uiImage: post.image!)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text("Username: \(post.caption)")
                                        .multilineTextAlignment(.leading)
                                        .font(.title3)
                                }.padding(25)
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
