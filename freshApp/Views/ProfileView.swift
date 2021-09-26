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
    
    let user: User
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                HStack {
                    Text(user.username)
                }
                ScrollView {
                    Spacer()
                    ForEach(fb.posts) { post in
                        HStack {
                            Image(uiImage: post.image)
                                .resizable()
                                .frame(width: 120, height: 120)
                            
                            Text(post.title)
                                .font(.body)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(id: "asdf", username: "Trevor Buhler", name: "Trevor Buhler", profileImage: UIImage(systemName: "person")!))
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
