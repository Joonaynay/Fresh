//
//  ProfilePictureView.swift
//  freshApp
//
//  Created by Forrest Buhler on 10/2/21.
//

import SwiftUI
import FirebaseAuth

struct InAppProfilePictureView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var imagePickerShowing: Bool = false
    @State private var image: UIImage?
    
    
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        pres.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(Font.headline.weight(.bold))
                            .padding()
                    })
                    Spacer()
                }
                
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
                        fb.currentUser.profileImage = image
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
}

struct ProfilePictureView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    @State private var imagePickerShowing: Bool = false
    @State private var image: UIImage?
    @Environment(\.presentationMode) var pres
    
    
    var body: some View {
        VStack {
            
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
                    fb.signedIn = true
                    fb.currentUser.profileImage = image
                    pres.wrappedValue.dismiss()
                    fb.file.saveImage(image: image, name: Auth.auth().currentUser!.uid)
                }
            }, label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.theme.pinkColor)
            })
            .padding(.horizontal)
            Button(action: { fb.signedIn = true }, label: {
                Text("Skip")
                    .frame(width: UIScreen.main.bounds.width / 2.5, height: 45)
                    .background(Color.theme.secondaryText)
            })
            .padding(5)
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
            .preferredColorScheme(.dark)
        SignUpView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}

