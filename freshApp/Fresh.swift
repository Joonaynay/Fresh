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
    
    @State private var notEmailVerified: Bool = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .fullScreenCover(isPresented: $notEmailVerified, content: {
                        WaitingForEmailVerification(selection: .constant(nil), dissmissView: .constant(nil))
                    })
                    .navigationBarHidden(true)
                    .onAppear() {
                        if let user = Auth.auth().currentUser {
                            if user.isEmailVerified {
                                print("Signed In")
                                fb.signedIn = true
                            } else {
                                notEmailVerified = true
                            }
                        }
                        
                        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.theme.accentColor)
                        
                        let tab = UITabBar.appearance()
                        tab.backgroundImage = UIImage()
                        tab.backgroundColor = UIColor(Color.theme.tabBarColor)
                        tab.shadowImage = UIImage()
                                                    
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(fb)
            .environmentObject(vm)
            .environmentObject(searchTest)
        }
    }
}
