//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var animate: Bool = false
    let user: User
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
                
                NavigationLink(
                    destination: inAppProfilePictureView(),
                    tag: profilePictureTag,
                    selection: $selection,
                    label: {})
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


struct inAppProfilePictureView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var imagePickerShowing: Bool = false
    @State private var image: UIImage?
    private let profileViewTag: String = "profileViewTag"
    @State private var selection: String? = ""
    
    
    var body: some View {
        VStack {
            Button(action: { pres.wrappedValue.dismiss() }, label: {
                Image(systemName: "chevron.left")
                    .font(Font.headline.weight(.bold))
                    .padding()
            })
            
            Text("Choose Profile Picture")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
            Spacer()
            Button(action: {
                imagePickerShowing = true
            }, label: {
                VStack {
                    if image == nil {
                        Text("Select an Image...")
                            .font(.title)
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding()
                    } else {
                        Text("Select an Image...")
                            .font(.title)
                        Image(uiImage: image!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipped()
                            .clipShape(Circle())
                            .padding()
                    }
                }
            })
            .sheet(isPresented: $imagePickerShowing, content: {
                ImagePickerView(image: $image)
            })
            
            Spacer()
            
            Button(action: {
                if let image = image {
                    fb.saveImage(path: "Profile Images", file: Auth.auth().currentUser!.uid, image: image)
                    fb.file.saveImage(image: image, name: Auth.auth().currentUser!.uid)
                    pres.wrappedValue.dismiss()
                }
            }, label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.theme.pinkColor)
            })
            .padding(.horizontal)
            
        }
        .navigationBarHidden(true)
    }
}
