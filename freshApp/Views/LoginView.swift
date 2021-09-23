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
    @State private var selection2: String? = ""
    private let tag = "HomeView"
    private let tag2 = "SignUp"
    
    
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
                       selection = tag
                    }
                    .overlay(
                        Text("Login")
                            .foregroundColor(.white)
                    )
                Rectangle()
                    .frame(width: 100, height: 45)
                    .foregroundColor(Color(#colorLiteral(red: 0.1129587665, green: 0.1133331135, blue: 0.1243050769, alpha: 1)))
                    .onTapGesture {
                        selection2 = tag2
                    }
                    .overlay(
                        Text("Sign Up")
                            .foregroundColor(.white)
                    )
                }
                .padding()
            }
            NavigationLink(
                destination: HomeView(),
                tag: tag,
                selection: $selection,
                label: {})
            
            NavigationLink(
                destination: SignUpView(),
                tag: tag2,
                selection: $selection2,
                label: {})
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
