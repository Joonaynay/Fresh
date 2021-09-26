//
//  VideoView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/25/21.
//

import SwiftUI

struct VideoView: View {
    
    let post: Posts
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
        Image(uiImage: post.image)
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
            Text(post.title)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding()
            HStack {
                NavigationLink(
                    destination: ProfileView(user: fb.currentUser!),
                    label: {
                        HStack {
                            Image(uiImage: post.user.profileImage)
                            .resizable()
                            .frame(width: 30, height: 30)
                            Text(post.user.username)
                        }
                    })
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Follow")
                        .frame(width: UIScreen.main.bounds.width / 3.5, height: 45)
                        .background(Color.theme.pinkColor)
                })
            }
            .padding(.horizontal)
            .padding(.bottom)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.secondaryText)
            Text("This is my comments.")
                .padding()
            Spacer()
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(post: Posts(id: "ds", image: UIImage(systemName: "person")!, title: "ds", subjects: ["sd", "ds"], date: "ds", user: User(id: "ds", username: "ds", name: "ds", profileImage: UIImage(systemName: "person")!)))
    }
}
