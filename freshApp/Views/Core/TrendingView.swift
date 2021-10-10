//
//  TrendingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct TrendingView: View {
    
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var offSetY: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Text("\(offSetY)")
                TitleBarView(title: "Trending")
                if fb.loading {
                    ProgressView()
                }
                ScrollView(showsIndicators: false) {
                    ZStack {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.clear)
                        VStack {
                            ForEach(fb.posts) { post in
                                PostView(post: post)
                            }
                        }
                    }
                }
                .offset(y: offSetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            offSetY = value.translation.height
                            if offSetY >= 10 && fb.loading == false {
                                fb.loadPosts()
                                offSetY = 0
                            }
                        })
                        .onEnded({ value in
                            offSetY = 0
                        })
                )
            }
            
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        
        
        .navigationBarHidden(true)
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
            .environmentObject(FirebaseModel())
    }
}
