//
//  FirebaseAuthModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/27/21.
//

import SwiftUI
import FirebaseAuth



struct FirebaseAuthModel {
    
    @EnvironmentObject var fb: FirebaseModel
    let auth = Auth.auth()
    let db = FirestoreModel()
    
    
    func loadCurrentUser() -> String {
        let id = auth.currentUser?.uid
        return id!
    }
    
    
    func signIn(email: String, password: String) {
        DispatchQueue.main.async {
            fb.loading = true
            self.auth.signIn(withEmail: email, password: password) { result, error in
                if result != nil && error == nil {
                    fb.signedIn = true
                    fb.loading = false
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, username: String) -> String {
        var errorString: String = ""
        
        self.auth.createUser(withEmail: email, password: password) { result, error in
            if result != nil && error == nil {
                // Save in Firestore
                let dict = ["name": name, "username": username, "posts": [], "followers": [], "following": []] as [String : Any]
                db.newDoc(collection: "users", document: auth.currentUser?.uid, data: dict) { uid in }
                                
            } else {
                errorString = error!.localizedDescription
            }
        }
        return errorString
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch let error {
            print("Error signing out. \(error)")
        }
        
        fb.signedIn = false
    }
}
