//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    let post: Post?
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    let user: User
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                if user.profileImage == nil {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    
                } else {
                    Image(uiImage: user.profileImage!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                }
                Button(action: {}, label: {
                    Text("Follow")
                        .frame(width: UIScreen.main.bounds.width / 3.5, height: 45)
                        .background(Color.theme.pinkColor)
                })
                .padding()
                HStack {
                    VStack {
                        Text("\(fb.currentUser.followers.count)")
                        Text("Followers")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding()
                    VStack {
                        Text("\(fb.currentUser.following.count)")
                        Text("Following")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding()
                }
                ScrollView {
                    ForEach(<#T##data: _##_#>, content: <#T##(_.Element) -> _#>)
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(id: "ds", username: "joonaynay", name: "jon", profileImage: nil, following: [], followers: []))
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
