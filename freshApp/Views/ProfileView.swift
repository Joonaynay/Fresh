//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var animate: Bool = false
    let user: User
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: { pres.wrappedValue.dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(Font.headline.weight(.bold))
                            .padding()
                    })
                    Spacer()
                }
                
                if user.profileImage == nil {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    
                } else {
                    Image(uiImage: user.profileImage!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .clipShape(Circle())                        
                }
                Text(user.username)
                Button(action: {
                    withAnimation(.spring()) {
                        animate.toggle()
                    }
                    fb.followUser(currentUser: fb.currentUser, followUser: user)
                }, label: {
                    Text(animate ? "Unfollow" : "Follow")
                        .frame(width: animate ? (UIScreen.main.bounds.width / 2.5) : (UIScreen.main.bounds.width / 3.5), height: 45)
                        .background(Color.theme.pinkColor)
                    
                })
                .padding()
                HStack {
                    VStack {
                        Text("\(user.followers.count)")
                        Text("Followers")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding()
                    VStack {
                        Text("\(user.following.count)")
                        Text("Following")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding()
                }
                ScrollView {
                    
                }
            }
        }
        .navigationBarHidden(true)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(id: "asd", username: "ds", name: "ds", profileImage: nil, following: [], followers: [], numFollowers: 0, numFollowing: 0, posts: nil))
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
