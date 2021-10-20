//
//  MainView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    @State var tab: Int = 1
    @State private var dissmissView: Bool? = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        if fb.signedIn && Auth.auth().currentUser?.isEmailVerified == true {
            TabView(selection: $tab) {
                TrendingView().tabItem { Image(systemName: "network") }.tag(1)
                HomeView().tabItem { Image(systemName: "list.dash") }.tag(2)
                FollowingView().tabItem { tab == 3 ? Image(systemName: "person.2.fill") : Image(systemName: "person.2") }.tag(3)
                SearchView().tabItem { Image(systemName: "magnifyingglass") }.tag(4)
            }            
            .navigationBarHidden(true)
        } else {
            LoginView()
                .environmentObject(fb)
        }
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}

