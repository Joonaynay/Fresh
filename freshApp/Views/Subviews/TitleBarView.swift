//
//  TitleBarView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/23/21.
//

import SwiftUI

struct TitleBarView: View {
    
    @State var selection: String? = ""
    @State var profileView = "profileView"
    
    let title: String
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Menu {
                    Button("View Profile") { selection = profileView }
                    Button("Settings") {}
                } label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                        .padding()
                }
            }
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.secondaryText)
            NavigationLink(destination: ProfileView(), tag: profileView, selection: $selection, label: {})
        }
    }
}

struct TitleBarView_Previews: PreviewProvider {
    static var previews: some View {
        TitleBarView(title: "Title")
            .environmentObject(FirebaseModel())
    }
}
