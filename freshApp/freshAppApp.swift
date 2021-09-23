//
//  freshAppApp.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

@main
struct freshAppApp: App {
    
    @StateObject var fb = FirebaseModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environmentObject(fb)
            }
        }
    }
}
