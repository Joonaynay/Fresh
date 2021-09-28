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
                    Button("View Profile") { selection = profileViewTag }
                    Button("New Post") {  selection = addPostViewTag }
                    Button("Settings") { }
                    Button(action: { fb.signOut() }, label: { Text("Sign Out") })
                } label: {
                    if fb.currentUser.profileImage != nil {
                        Image(uiImage: fb.currentUser.profileImage!)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .padding()
                            
                    } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                        .padding()
                    }
                }
            }
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.secondaryText)
            NavigationLink(destination: ProfileView(user: fb.currentUser), tag: profileViewTag, selection: $selection, label: {})
            
            NavigationLink(destination: AddPostView(), tag: addPostViewTag, selection: $selection, label: {})

        }
    }
}

struct TitleBarView_Previews: PreviewProvider {
    static var previews: some View {
        TitleBarView(title: "Title")
            .environmentObject(FirebaseModel())
    }
}
