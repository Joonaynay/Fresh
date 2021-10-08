//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    let user: User
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        if user.id == fb.currentUser.id {
            CurrentProfileView()
        } else {
            PostProfileView(user: user)
        }
    }
}

struct PostProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var animate: Bool = false
    @State var user: User
    private let profilePictureTag: String = "profilePictureTag"
    @State private var selection: String? = ""
    
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
                Button(action: {
                    selection = profilePictureTag
                }, label: {
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
                })
                
                Text(user.username)
                Button(action: {
                    withAnimation(.spring()) {
                        animate.toggle()
                    }
                    fb.followUser(followUser: user)
                }, label: {
                    Text(animate ? "Unfollow" : "Follow")
                        .frame(width: animate ? (UIScreen.main.bounds.width / 2.5) : (UIScreen.main.bounds.width / 3.5), height: 45)
                        .background(Color.theme.pinkColor)
                    
                })
                .padding()
                .onAppear() {
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(user.id).addSnapshotListener { doc, error in
                        
                        self.user.followers = doc?.get("followers") as? [String]
                        if self.user.followers!.contains(fb.currentUser.id) {
                            animate = true
                        }
                    }
                }
                HStack {
                    VStack {
                        Text("\(user.followers!.count)")
                        Text("Followers")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding()
                    VStack {
                        Text("\(user.following!.count)")
                        Text("Following")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding()
                }
                ScrollView {
                    
                }
                
                NavigationLink(
                    destination: InAppProfilePictureView(),
                    tag: profilePictureTag,
                    selection: $selection,
                    label: {})
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(Color.theme.accent)
    }
}

struct CurrentProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    private let profilePictureTag: String = "profilePictureTag"
    @State private var selection: String? = ""
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            ScrollView {
                
                VStack {
                    HStack {
                        Button(action: { pres.wrappedValue.dismiss() }, label: {
                            Image(systemName: "chevron.left")
                                .font(Font.headline.weight(.bold))
                                .padding()
                        })
                        Spacer()
                    }
                    Button(action: {
                        selection = profilePictureTag
                    }, label: {
                        if fb.currentUser.profileImage == nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                        } else {
                            Image(uiImage: fb.currentUser.profileImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .clipShape(Circle())
                        }
                    })
                    
                    Text(fb.currentUser.username)
                    Button(action: {
                        
                    }, label: {
                        Text("Edit Profile")
                            .frame(width: UIScreen.main.bounds.width / 3.5, height: 45)
                            .background(Color.theme.pinkColor)
                        
                    })
                    .padding()
                    HStack {
                        VStack {
                            Text("\(fb.currentUser.followers!.count)")
                            Text("Followers")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding()
                        VStack {
                            Text("\(fb.currentUser.following!.count)")
                            Text("Following")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding()
                    }
                    // Why does this not work???
                    ForEach(fb.posts) { post in
                        if post.user.id == fb.currentUser.id {
                            Image(uiImage: post.image)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width / 1.10, height: UIScreen.main.bounds.width / 1.10)
                        } else {
                            Image(uiImage: post.image)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width / 1.10, height: UIScreen.main.bounds.width / 1.1)
                        }
                    }
                }
                
                NavigationLink(
                    destination: InAppProfilePictureView(),
                    tag: profilePictureTag,
                    selection: $selection,
                    label: {})
            }
        }
        .navigationBarHidden(true)
        .foregroundColor(Color.theme.accent)
    }
}




