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

// Someone elses profile view.
struct PostProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var animate: Bool = false
    @State var user: User
    private let profilePictureTag: String = "profilePictureTag"
    @State private var selection: String? = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { pres.wrappedValue.dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(Font.headline.weight(.bold))
                            .padding()
                    })
                    Spacer()
                }
                ScrollView(showsIndicators: false) {
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
                        .padding()
                    HStack {
                        Button(action: {
                            animate.toggle()
                            fb.followUser(followUser: user)
                        }, label: {
                            Text(animate ? "Unfollow" : "Follow")
                                .frame(width: animate ? (UIScreen.main.bounds.width / 2.5) : (UIScreen.main.bounds.width / 3.5), height: 45)
                                .foregroundColor(Color.theme.blueTextColor)
                                .background(Color.theme.blueColor)
                            
                        })
                        VStack {
                            Text("\(user.followers.count)")
                            Text("Followers")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    .padding(.bottom, 20)
                    .onAppear() {
                        let db = Firestore.firestore()
                        
                        db.collection("users").document(user.id).addSnapshotListener { doc, error in
                            
                            self.user.followers = doc?.get("followers") as! [String]
                            if self.user.followers.contains(fb.currentUser.id) {
                                animate = true
                            }
                        }
                        fb.loadProfilePosts(user: user)
                    }
                    LazyVGrid(columns: [GridItem(spacing: 3), GridItem(spacing: 3)]) {
                        if let posts = user.posts {
                            ForEach(posts) { post in
                                VStack {
                                    Image(uiImage: post.image)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 2.1, height: (UIScreen.main.bounds.width / 2.1) * 9/16)
                                    Text("\(post.title)")
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
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

// Your profile view.
struct CurrentProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    @Environment(\.colorScheme) var colorScheme
    @State private var showSheet: Bool = false
    
    private let profilePictureTag: String = "profilePictureTag"
    @State private var selection: String? = ""
    @State var dismissView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { pres.wrappedValue.dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(Font.headline.weight(.bold))
                            .padding()
                    })
                    Spacer()
                }
                ScrollView(showsIndicators: false) {
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
                        .padding()
                    HStack {
                        Button(action: {
                            showSheet = true
                        }, label: {
                            Text("Edit Profile")
                                .frame(width: UIScreen.main.bounds.width / 2.5, height: 45)
                                .foregroundColor(Color.theme.blueTextColor)
                                .background(Color.theme.blueColor)
                            
                        })
                        VStack {
                            Text("\(fb.currentUser.followers.count)")
                            Text("Followers")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .onAppear() {
                            let db = Firestore.firestore()
                            if !fb.currentUser.id.isEmpty {
                                db.collection("users").document(fb.currentUser.id).addSnapshotListener { doc, error in
                                    if error == nil {
                                        fb.currentUser.followers = doc?.get("followers") as! [String]
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    LazyVGrid(columns: [GridItem(spacing: 3), GridItem(spacing: 3)]) {
                        ForEach(fb.posts) { post in
                            if post.user.id == fb.currentUser.id {
                                VStack {
                                    Image(uiImage: post.image)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 2.1, height: (UIScreen.main.bounds.width / 2.1) * 9/16)
                                    Text("\(post.title)")
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
                NavigationLink(
                    destination: ProfilePictureView(showSkipButton: false),
                    tag: profilePictureTag,
                    selection: $selection,
                    label: {})
            }
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        .onChange(of: dismissView, perform: { _ in
            if dismissView {
                pres.wrappedValue.dismiss()
            }
        })
        .navigationBarHidden(true)
        .sheet(isPresented: $showSheet, content: {
            EditProfileView(dismissView: $dismissView)
        })
    }
}




