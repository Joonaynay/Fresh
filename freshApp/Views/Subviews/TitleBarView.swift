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
    
    let title: String
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Menu() {
                    Button("View Profile") { selection = profileViewTag }
                    Button("New Post") { selection = addPostViewTag }
                    Button("Settings") {}
                    Button(action: { fb.signOut() }, label: { Text("Sign Out").accentColor(.red) }).accentColor(.red)
                } label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                        .padding()
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.secondaryText)
            NavigationLink(destination: ProfileView(), tag: profileViewTag, selection: $selection, label: {})
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
