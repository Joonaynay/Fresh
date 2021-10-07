//
//  freshAppApp.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct freshAppApp: App {
    
    @StateObject var fb = FirebaseModel()
    @StateObject var vm = SearchBar()
    @StateObject var searchTest = SearchBar2Test()

    
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .navigationBarHidden(true)
                    .foregroundColor(Color.theme.accent)
                    .onAppear() {
                        if (Auth.auth().currentUser != nil) && (Auth.auth().currentUser?.isEmailVerified != nil) {
                            fb.signedIn = true
                        }
                    }

            }
            .environmentObject(fb)
            .environmentObject(vm)
            .environmentObject(searchTest)
        }
    }
}
