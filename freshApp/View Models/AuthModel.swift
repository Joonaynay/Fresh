//
//  FirebaseAuthModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/27/21.
//

import SwiftUI
import FirebaseAuth



extension FirebaseModel {
    
    
    func signIn(email: String, password: String) {
        
        self.loading = true
        self.auth.signIn(withEmail: email, password: password) { result, error in
            if result != nil && error == nil {
                self.signedIn = true
                self.loading = false
            }
        }
        
    }
    
    func signUp(email: String, password: String, name: String, username: String, completion:@escaping (String?) -> Void) {
        //Create User
        self.auth.createUser(withEmail: email, password: password) { result, error in
            
            //Check for success
            if result != nil && error == nil {
                
                // Save data in Firestore
                let dict = ["name": name, "username": username, "posts": [], "followers": [], "following": []] as [String : Any]
                self.newDoc(collection: "users", document: self.auth.currentUser?.uid, data: dict) { uid in }
                
            } else {
                // Return Error
                completion(error?.localizedDescription)
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch let error {
            print("Error signing out. \(error)")
        }
        
        self.signedIn = false
    }
}