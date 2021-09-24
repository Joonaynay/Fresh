//
//  freshAppApp.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import Firebase

@main
struct freshAppApp: App {
    
    @StateObject var fb = FirebaseModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(tab: 1)
                    .onAppear() {
                        if Auth.auth().currentUser != nil {
                            fb.signedIn = true
                        }
                    }
            }
            .environmentObject(fb)
        }
    }
}
