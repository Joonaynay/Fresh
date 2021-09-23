//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var posts: [String] = ["sadg", "asdg", "kfk", "hyf", "jkk"]
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            ScrollView {
                NavigationLink(
                    destination: AddPostView(),
                    label: {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(Color.theme.pinkColor)
                            .overlay(
                                Text("Add Post")
                                    .foregroundColor(.white)
                            )
                    })

                Spacer()
                ForEach(posts, id: \.self) { post in
                    HStack {
                        Rectangle()
                            .frame(width: 120, height: 120)
                        
                        Text("This will be the title of whatever the title screen is.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
