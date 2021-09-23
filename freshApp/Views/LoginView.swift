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
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 200, height: 150)
                TextField("Username", text: $username)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.theme.secondaryText)
                    .padding(.horizontal)
                SecureField("Password", text: $password)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.theme.secondaryText)
                    .padding(.horizontal)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
