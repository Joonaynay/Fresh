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
                    Alert(title: Text("Incorrect email or password"))
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
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .foregroundColor(Color.theme.pinkColor)
                            .overlay(
                                Text("Login")
                                    .foregroundColor(.white)
                            )
                    })

                    Rectangle()
                        .frame(width: 100, height: 45)
                        .foregroundColor(Color(#colorLiteral(red: 0.1129587665, green: 0.1133331135, blue: 0.1243050769, alpha: 1)))
                        .onTapGesture {
                            selection = tag
                        }
                        .overlay(
                            Text("Sign Up")
                                .foregroundColor(.white)
                        )
                }
                .padding()
            }
            
            NavigationLink(
                destination: SignUpView(),
                tag: tag,
                selection: $selection,
                label: {})
            if fb.loading {
                LoadingView()
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
    @State private var showAlert: Bool = false
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                Section(header: Text("Email")) {
                    TextField("Email", text: $email)
                }
                Section(header: Text("Password")) {
                    TextField("Password", text: $password)
                    TextField("Confirm Password", text: $confirmPassword)
                }
            }
            Button("Create Account") {
                if password == confirmPassword {
                    fb.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
                } else {
                    showAlert.toggle()
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Invalid data."))
            })
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(Color.theme.pinkColor)
        }
        .navigationTitle("Create Account")
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
