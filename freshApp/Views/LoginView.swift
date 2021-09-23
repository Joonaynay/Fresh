//
//  LoginView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selection: String? = ""
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
                TextField("Username", text: $username)
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
                .padding()
                VStack {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .foregroundColor(Color.theme.pinkColor)
                    .onTapGesture {
                        fb.signedIn = true
                    }
                    .overlay(
                        Text("Login")
                            .foregroundColor(.white)
                    )
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
        }
    }
}

struct SignUpView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var selection: String? = ""
    private let tag = "NewHomeView"
    
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
                selection = tag
            }
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(Color.theme.pinkColor)
            
            NavigationLink(
                destination: HomeView(),
                tag: tag,
                selection: $selection,
                label: {})
        }
        .navigationTitle("Create Account")
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
