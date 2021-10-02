//
//  LoginView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selection: String? = ""
    @State private var showAlert: Bool = false
    private let tag = "SignUp"
    @EnvironmentObject var fb: FirebaseModel
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 200, height: 150)
                Spacer()
                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.secondaryText)
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.secondaryText)
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Incorrect email or password. Try Again."))
                })
                .padding()
                VStack {
                    Button(action: {
                        self.hideKeyboard()
                        fb.signIn(email: email, password: password)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if fb.loading {
                                fb.loading = false
                                showAlert = true
                            }
                        }                        
                    }, label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.theme.pinkColor)
                    })
                    .padding(.horizontal)
                    Button(action: { selection = tag}, label: {
                        Text("Create Account")
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 45)
                            .background(Color.theme.secondaryText)
                    })
                    .padding(5)
                    .padding(.bottom)
                }
                
            }
            
            NavigationLink(
                destination: SignUpView(),
                tag: tag,
                selection: $selection,
                label: {})
            if fb.loading {
                LoadingView(text: nil)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SignUpView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var username: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    
    @State private var selection: String? = ""
    private let profilePictureTag = "profilePicture"
    
    @State private var emailVerifyWaiting: Bool = false
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Form {
                    Section(header: Text("Name")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }
                    Section(header: Text("Username (Users will see this name.)")) {
                        TextField("Username", text: $username)
                    }
                    Section(header: Text("Email")) {
                        TextField("Email", text: $email)
                    }
                    Section(header: Text("Password")) {
                        SecureField("Password", text: $password)
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                }
                Button(action: {
                    fb.signUp(email: email, password: password, name: "\(firstName) \(lastName)", username: username) { errorMessage in
                        if errorMessage != nil {
                            alertText = errorMessage!
                            showAlert.toggle()
                        } else {
                            emailVerifyWaiting = true
                        }
                    }
                }, label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.theme.pinkColor)
                })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text(alertText))
                })
            }
            .fullScreenCover(isPresented: $emailVerifyWaiting, content: {
                WaitingForEmailVerification(selection: $selection)
            })
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            NavigationLink(destination: ProfilePictureView(), tag: profilePictureTag, selection: $selection, label: {})
        }
    }
}

struct WaitingForEmailVerification: View {
    
    @Binding var selection: String?
    private let profilePictureTag = "profilePicture"
    
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) private var pres
    
    var body: some View {
        VStack {
            Text("Waiting for email to be verified.")
            Text("You should have recieved an email with a link to verify your account.")
                .font(.caption2)
            ProgressView()
            Button(action: {
                DispatchQueue.main.async {
                    Auth.auth().currentUser?.reload(completion: { error in
                        if let error = error {
                            fatalError(error.localizedDescription)
                        } else {
                            if Auth.auth().currentUser!.isEmailVerified {
                                pres.wrappedValue.dismiss()
                                selection = profilePictureTag
                            } else {
                                showAlert = true
                            }
                        }
                    })
                }
            }, label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.theme.pinkColor)
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Please verify your email."))
        }
    }
}

struct ProfilePictureView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    @State private var imagePickerShowing: Bool = false
    @State private var image: UIImage?
    
    
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
                            .scaledToFit()
                            .padding()
                    } else {
                        Text("Select an Image...")
                            .font(.title)
                        Image(uiImage: image!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                            .scaledToFit()
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
