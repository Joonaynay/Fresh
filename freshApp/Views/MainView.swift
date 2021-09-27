//
//  MainView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI
import Firebase

struct MainView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    @State var tab: Int = 1
    
    var body: some View {
        
        if fb.signedIn {
            TabView(selection: $tab) {
                TrendingView().tabItem { Image(systemName: "network") }.tag(1)
                HomeView().tabItem { Image(systemName: "list.dash") }.tag(2)
                FollowingView().tabItem { tab == 3 ? Image(systemName: "person.2.fill") : Image(systemName: "person.2") }.tag(3)
            }
            .onAppear() {
                if Auth.auth().currentUser != nil {
                    fb.loadCurrentUser()
                }
            }
        } else {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(tab: 1)
            .environmentObject(FirebaseModel())
        }
    }
}
