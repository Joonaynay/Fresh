//
//  TitleBarView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/23/21.
//

import SwiftUI

struct TitleBarView: View {
    
    @State private var selection: String? = ""
    @State private var profileViewTag = "profileView"
    @State private var addPostViewTag = "addPostView"
    @State private var showAlert: Bool = false
    
    @EnvironmentObject var fb: FirebaseModel
    
    @Environment(\.presentationMode) var pres
        
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Menu {
                    Button("Profile") { selection = profileViewTag }
                    Button("New Post") {  selection = addPostViewTag }
                    Button(action: { showAlert = true }, label: { Text("Sign Out") })
                } label: {
                    if fb.currentUser.profileImage != nil {
                        Image(uiImage: fb.currentUser.profileImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45, height: 45)
                            .clipped()
                            .clipShape(Circle())
                            .padding()
                            
                    } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                    }
                }
            }
            Color.theme.lineColor.frame(maxWidth: .infinity, maxHeight: 1)
            NavigationLink(destination: ProfileView(user: fb.currentUser), tag: profileViewTag, selection: $selection, label: {})
            
            NavigationLink(destination: AddPostView(), tag: addPostViewTag, selection: $selection, label: {})

        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Are you sure you want to sign out?"), primaryButton: Alert.Button.cancel(Text("Cancel").foregroundColor(Color.blue)), secondaryButton: Alert.Button.default(Text("Sign Out").foregroundColor(Color.theme.blueColor), action: {
                fb.signOut()
            }))
        })
    }
}

struct TitleBarView_Previews: PreviewProvider {
    static var previews: some View {
        TitleBarView(title: "Title")
            .environmentObject(FirebaseModel())
    }
}
