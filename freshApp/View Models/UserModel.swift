//
//  UserModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import Firebase
 
struct User: Identifiable {
    let id: String
    let username: String
    let name: String?
    var profileImage: UIImage?
    var following: [String]?
    var followers: [String]?
    let posts: [String]?
}

extension FirebaseModel {
    func followUser(followUser: User) {
        if !followUser.followers!.contains(currentUser.id) {
            //Save who the user followed
            self.save(collection: "users", document: currentUser.id, field: "following", data: [followUser.id])
            
            //Save that the followed user got followed
            self.save(collection: "users", document: followUser.id, field: "followers", data: [currentUser.id])
            
            //Add to UserModel
            
            self.currentUser.following!.append(followUser.id)
            
            //Save to core data
            let coreUser = cd.fetchUser(uid: currentUser.id)
            coreUser?.following?.append(followUser.id)
            cd.save()
            
        } else {
            db.collection("users").document(followUser.id).updateData(["followers": FieldValue.arrayRemove([currentUser.id])])
            db.collection("users").document(currentUser.id).updateData(["following": FieldValue.arrayRemove([followUser.id])])
            
            // Delete from UserModel
            let index = currentUser.following?.firstIndex(of: followUser.id)
            currentUser.following?.remove(at: index!)
            
            //Save to core data
            let deleteCoreUser = cd.fetchUser(uid: currentUser.id)
            let newIndex = deleteCoreUser?.following?.firstIndex(of: followUser.id)
            deleteCoreUser?.following?.remove(at: newIndex!)
            cd.save()
            
        }
        
    }
    func loadConservativeUser(uid: String, completion:@escaping (User?) -> Void) {
        
        //Check if can load from Core Data
        if let user = cd.fetchUser(uid: uid) {
        
            print("Loaded User From Core Data")
            
            
            if let profileImage = self.file.getFromFileManager(name: uid) {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: profileImage, following: user.following!, followers: user.followers!, posts: nil))
            } else {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: nil, following: user.following!, followers: user.followers!, posts: nil))
            }
            
        } else {
            
            //Load Firestore doc
            getDoc(collection: "users", id: uid) { doc in
                                
                print("Loaded User From Firebase")                
                
                let username = doc?.get("username") as! String
                
                //Load Profile Image
                self.loadImage(path: "Profile Images", id: uid) { profileImage in                
                    
                    
                    //Create User
                    let user = User(id: uid, username: username, name: nil, profileImage: profileImage, following: nil, followers: nil, posts: nil)
                    
                    //Return User
                    completion(user)
                }
            }
        }        
    }
    
    func loadUser(uid: String, completion:@escaping (User?) -> Void) {
        
        
        //Check if can load from Core Data
        if let user = cd.fetchUser(uid: uid) {
            print("Loaded User From Core Data")
            
            if let profileImage = self.file.getFromFileManager(name: uid) {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: profileImage, following: user.following!, followers: user.followers! ,posts: nil))
            } else {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: nil, following: user.following!, followers: user.followers! ,posts: nil))
            }
            
        } else {
            
            //Load Firestore doc
            getDoc(collection: "users", id: uid) { doc in
                
                print("Loaded User From Firebase")
                
                
                let username = doc?.get("username") as! String
                let name = doc?.get("name") as! String
                let following = doc?.get("following") as! [String]
                let followers = doc?.get("followers") as! [String]
                let posts = doc?.get("posts") as! [String]
                
                //Load Profile Image
                self.loadImage(path: "Profile Images", id: uid) { profileImage in
                    
                    //Core Data
                    
                    
                    //Create User
                    let user = User(id: uid, username: username, name: name, profileImage: profileImage, following: following, followers: followers, posts: posts)
                    
                    //Return User
                    completion(user)
                }
            }
        }
    }
    
}
