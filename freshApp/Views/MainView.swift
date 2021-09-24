//
//  MainView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    
    
    var body: some View {
        
        if fb.signedIn {
            TabView {
                SearchView().tabItem { Image(systemName: "network") }
                HomeView().tabItem { Image(systemName: "list.dash") }
                FollowingView().tabItem { Image(systemName: "person.2") }


            }
        } else {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        MainView()
            .environmentObject(FirebaseModel())
        }
    }
}
