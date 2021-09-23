//
//  MainView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            
            HomeView().tabItem { Image(systemName: "house.fill") }
            SearchView().tabItem { Image(systemName: "magnifyingglass") }
            FollowingView().tabItem { Image(systemName: "list.dash") }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
