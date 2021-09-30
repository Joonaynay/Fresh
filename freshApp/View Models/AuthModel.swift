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
        //Set loading to true
        self.loading = true
        
        //Create User
        self.auth.createUser(withEmail: email, password: password) { [self] result, error in
            
            //Save to Core Data
            let currentUser = CurrentUser(context: self.cd.context)
            currentUser.username = username
            currentUser.id = self.auth.currentUser?.uid
            currentUser.name = name
            currentUser.followers = 0
            currentUser.following = 0
            self.cd.save()
            
            //Check for success
            if result != nil && error == nil {
                
                // Save data in Firestore
                let dict = ["name": name, "username": username, "posts": [], "followers": [], "following": []] as [String : Any]
                self.newDoc(collection: "users", document: self.auth.currentUser?.uid, data: dict) { uid in }
                
                //Send Email Verification
                self.auth.currentUser!.sendEmailVerification(completion: { error in
                    if error != nil {
                        self.loading = false
                        completion(error?.localizedDescription)
                    } else {
                        self.loading = false
                        completion(nil)
                    }
                })
                
                
            } else {
                // Return Error
                self.loading = false
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
