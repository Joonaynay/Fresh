//
//  EditProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/7/21.
//

import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    @State private var showAlert: Bool = false
    @Binding var dismissView: Bool
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Change Username")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme.accentColor)
                }
                .padding(10)
                HStack {
                    Text("Change Password")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme.accentColor)
                }
                .padding(10)
                HStack {
                    Text("Change Email")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme.accentColor)
                }
                .padding(10)
                Button(action: { showAlert = true }, label: {
                    Text("Sign Out")
                .foregroundColor(Color.theme.accentColor)
                .padding(10)
                })
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Are you sure you want to sign out?"), primaryButton: Alert.Button.cancel(Text("Cancel")), secondaryButton: Alert.Button.default(Text("Sign Out"), action: {
                dismissView = true
                pres.wrappedValue.dismiss()
                fb.signOut()
            }))
        })
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(dismissView: .constant(false))
            .environmentObject(FirebaseModel())
    }
}
