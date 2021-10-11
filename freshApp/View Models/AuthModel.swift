//
//  FirebaseAuthModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/27/21.
//

import SwiftUI
import FirebaseAuth
import CoreData



extension FirebaseModel {
    
    func changeEmail(email: String, completion:@escaping (String?) -> Void) {
        auth.currentUser?.updateEmail(to: email, completion: { error in
            if let error = error  {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
            
        })
    }
    
    
    func signIn(email: String, password: String) {
        
        self.loading = true
        self.auth.signIn(withEmail: email, password: password) { result, error in
            if result != nil && error == nil {
                
                //Save uid to userdefaults
                UserDefaults.standard.setValue(self.auth.currentUser?.uid, forKeyPath: "uid")
                self.signedIn = true
                self.loading = false
                self.loadUser(uid: self.auth.currentUser!.uid) { user in
                    if let user = user {
                        self.currentUser = user
                        
                        //Save to Core Data
                        let currentUser = CurrentUser(context: self.cd.context)
                        currentUser.username = user.username
                        currentUser.id = self.auth.currentUser?.uid
                        currentUser.name = user.name
                        currentUser.followers = user.followers
                        currentUser.following = user.following
                        self.cd.save()
                        
                        //Save ProfileImage to FileManager
                        if let profileImage = user.profileImage {
                            self.file.saveImage(image: profileImage, name: user.id)
                        }
                    }
                }
            }
        }
        
    }
    
    func signUp(email: String, password: String, name: String, username: String, completion:@escaping (String?) -> Void) {
        //Set loading to true
        self.loading = true
        
        self.getDocs(collection: "users") { query in
            for doc in query!.documents {
                let otherUsername = doc.get("username") as! String
                if otherUsername == username {
                    self.loading = false
                    completion("That username is already taken.")
                    break
                }
                if doc == query!.documents.last && otherUsername != username {
                    //Create User
                    self.auth.createUser(withEmail: email, password: password) { [self] result, error in
                        
                        //Check for success
                        if result != nil && error == nil {
                            
                            //Save to Core Data
                            let currentUser = CurrentUser(context: self.cd.context)
                            currentUser.username = username
                            currentUser.id = self.auth.currentUser?.uid
                            currentUser.name = name
                            currentUser.followers = []
                            currentUser.following = []
                            self.cd.save()
                            
                            //Save uid to userdefaults
                            UserDefaults.standard.setValue(self.auth.currentUser?.uid, forKeyPath: "uid")
                            
                            
                            // Save data in Firestore
                            let dict = ["name": name, "username": username, "posts": [], "followers": [], "following": []] as [String : Any]
                            self.newDoc(collection: "users", document: self.auth.currentUser?.uid, data: dict) { uid in }
                            
                            //Send Email Verification
                            self.auth.currentUser!.sendEmailVerification(completion: { error in
                                if error != nil {
                                    self.loading = false
                                    completion(error?.localizedDescription)
                                } else {
                                    self.loadUser(uid: self.auth.currentUser!.uid) { user in
                                        self.currentUser = user!
                                    }
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
            }
        }
    }
    
    func signOut() {
        UserDefaults.standard.setValue(nil, forKeyPath: "uid")
        self.file.deleteAllImages()
        self.cd.deleteAll()
        self.cd.container = NSPersistentContainer(name: "FreshModel")
        self.cd.container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        self.cd.context = self.cd.container.viewContext
        do {
            try auth.signOut()
        } catch let error {
            print("Error signing out. \(error)")
        }        
        self.signedIn = false
    }
    
}
