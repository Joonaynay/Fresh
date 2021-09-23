//
//  SignUpView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
