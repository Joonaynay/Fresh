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
    
    @State private var emailVerifyWaiting: Bool = false
    private let signUpTag = "SignUp"
    private let profilePictureTag = "profilePicture"
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
                        .cornerRadius(2)
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Incorrect email or password. Try Again."))
                })
                .padding()
                VStack {
                    Button(action: {
                        self.hideKeyboard()
                        fb.signIn(email: email, password: password) { isEmailVerified in
                            if isEmailVerified {
                                fb.signedIn = true
                            } else {
                                emailVerifyWaiting = true
                            }
                        }                     
                    }, label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(Color.theme.blueTextColor)
                            .background(Color.theme.blueColor)
                            .cornerRadius(2)
                    })
                    .padding(.horizontal)
                    Button(action: { selection = signUpTag}, label: {
                        Text("Create Account")
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 45)
                            .foregroundColor(Color.theme.blueTextColor)
                            .cornerRadius(2)
                    })
                    .padding(2)
                    .padding(.bottom, 10)
                }
                
            }
            NavigationLink(destination: ProfilePictureView(showSkipButton: true), tag: profilePictureTag, selection: $selection, label: {})

            
            NavigationLink(
                destination: SignUpView(),
                tag: signUpTag,
                selection: $selection,
                label: {})
        }
        .fullScreenCover(isPresented: $emailVerifyWaiting, content: {
            WaitingForEmailVerification(selection: $selection, dissmissView: .constant(nil))
        })
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
    
    
    @State private var nextButtonDisabled: Bool = true
    @State private var emailVerifyWaiting: Bool = false
    
    @EnvironmentObject private var fb: FirebaseModel
    @State var dissmissView: Bool?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var pres
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(showsIndicators: false) {
                    TextField("First Name", text: $firstName)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                        .padding(.top)
                    TextField("Last Name", text: $lastName)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                        .padding(.top)
                    TextField("Username", text: $username)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                        .padding(.top)
                    TextField("Email", text: $email)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                        .padding(.top)
                    SecureField("Password", text: $password)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                        .padding(.top)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.theme.secondaryText)
                        .cornerRadius(2)
                        .padding(.top)
                }
                Button(action: {
                    fb.signUp(email: email, password: password, confirm: confirmPassword, name: "\(firstName) \(lastName)", username: username) { errorMessage in
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
                        .foregroundColor(nextButtonDisabled ? Color(.systemGray2) : Color.theme.blueTextColor)
                        .background(nextButtonDisabled ? Color(.systemGray3) : Color.theme.blueColor)
                        .cornerRadius(2)
                })
                .disabled(nextButtonDisabled)
            }
            .onChange(of: firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty, perform: { _ in
                if !firstName.isEmpty && !lastName.isEmpty && !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
                    nextButtonDisabled = false
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertText))
            })

            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            NavigationLink(destination: ProfilePictureView(showSkipButton: true), tag: profilePictureTag, selection: $selection, label: {})

        }
        .onChange(of: dissmissView, perform: { value in
            if dissmissView == true {
                pres.wrappedValue.dismiss()
            }
            
        })
        .fullScreenCover(isPresented: $emailVerifyWaiting, content: {
            WaitingForEmailVerification(selection: $selection, dissmissView: $dissmissView)
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
            HStack {
                Button {
                    fb.signOut()
                    pres.wrappedValue.dismiss()
                    dissmissView = true
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color.theme.blueTextColor)
                }
                .padding(.bottom)
                Spacer()
            }
            Text("Waiting for email to be verified...")
                .multilineTextAlignment(.center)
                .font(.title)
            Button {
                Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                })
            } label: {
                Text("Resend email verification code.")
            }
            .padding()

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

