//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var posts: [String] = ["sadg", "asdg", "kfk", "hyf", "jkk"]
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            ScrollView {
                Spacer()
                ForEach(fb.posts) { post in
                    HStack {
                        Image(uiImage: post.image!)
                            .resizable()
                            .frame(width: 120, height: 120)
                        
                        Text(post.caption)
                            .font(.body)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
