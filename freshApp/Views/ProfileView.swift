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
