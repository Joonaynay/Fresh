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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
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
                            .frame(height: 50)
                            .foregroundColor(Color.theme.blueTextColor)
                            .background(Color.theme.blueColor)
                    })
                    .padding(.horizontal)
                    Button(action: { selection = tag}, label: {
                        Text("Create Account")
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 45)
                            .background(Color.theme.blueColor)
                            .foregroundColor(Color.theme.blueTextColor)
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
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
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
    @State var dissmissView: Bool?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var pres
    
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
                        .frame(height: 50)
                        .foregroundColor(Color.theme.blueTextColor)
                        .background(Color.theme.blueColor)
                })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text(alertText))
                })
            }
            .fullScreenCover(isPresented: $emailVerifyWaiting, content: {
                WaitingForEmailVerification(selection: $selection, dissmissView: $dissmissView)
            })
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            NavigationLink(destination: ProfilePictureView(showSkipButton: true), tag: profilePictureTag, selection: $selection, label: {})
            if fb.loading {
                LoadingView(text: nil)
            }
        }
        .onChange(of: dissmissView, perform: { _ in
            pres.wrappedValue.dismiss()
        })
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}

struct WaitingForEmailVerification: View {
    
    @Binding var selection: String?
    private let profilePictureTag = "profilePicture"
    
    @EnvironmentObject private var fb: FirebaseModel
    
    @State private var newEmail: String? = ""
    @State private var changeEmailAlert: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    @Environment(\.presentationMode) private var pres
    
    @Binding var dissmissView: Bool?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Waiting for email to be verified...")
                .multilineTextAlignment(.center)
                .font(.title)
            Button("Cancel") {
                fb.signOut()
                pres.wrappedValue.dismiss()
                dissmissView = true
            }
            Spacer()
                .font(.caption2)
            ProgressView()
            Spacer()
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
                                alertText = "Please verify your email."
                            }
                        }
                    })
                }
            }, label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color.theme.blueTextColor)
                    .background(Color.theme.blueColor)
            })
            Text("You should have recieved an email with a link to verify your account.").multilineTextAlignment(.center)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertText))
        }
        .onChange(of: alertText, perform: { _ in
            showAlert = true
        })
    }
}

