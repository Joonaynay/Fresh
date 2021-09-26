//
//  FirebaseModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseModel: ObservableObject {
    
    @Published var signedIn = false
    @Published var posts: [Posts] = []
    @Published var loading = false
    @Published var currentUser = User(id: "", username: "", name: "", profileImage: nil, following: [], followers: [])
    let auth = Auth.auth()
    let storage = Storage.storage().reference()
    
    
    func followUser(currentUser: User, followUser: User) {
        let db = Firestore.firestore().collection("users")
        db.document(currentUser.id).updateData(["following": FieldValue.arrayUnion([followUser.id])])
        db.document(followUser.id).updateData(["followers": FieldValue.arrayUnion([currentUser.id])])
        self.currentUser.following.append(followUser.id)
    }
    
    func loadCurrentUser() {
        let id = auth.currentUser?.uid
        Firestore.firestore().collection("users").document(id!).getDocument { doc, error in
            let username = doc?.get("username") as! String
            let name = doc?.get("name") as! String
            let following = doc?.get("following") as! [String]
            let followers = doc?.get("followers") as! [String]
            self.storage.child("Profile Images").child(id!).getData(maxSize: 20 * 1024 * 1024) { data, error in
                if data != nil {
                    let image = UIImage(data: data!)
                    self.currentUser = User(id: id!, username: username, name: name, profileImage: image, following: following, followers: followers)
                } else {
                    self.currentUser = User(id: id!, username: username, name: name, profileImage: nil, following: following, followers: followers)

                }
            }
        }
    }
    
    func addProfilePicture(image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1)
        storage.child("Profile Images").child(auth.currentUser!.uid).putData(imageData!)
    }
    
    
    func loadUser(uid: String, completionHandler:@escaping (User?) -> Void) {
        
        let db = Firestore.firestore().collection("users")
        db.document(uid).getDocument { doc, error in
            let username = doc?.get("username") as! String
            let name = doc?.get("name") as! String
            let following = doc?.get("following") as! [String]
            let followers = doc?.get("followers") as! [String]
            self.storage.child("Profile Images").child(uid).getData(maxSize: 20 * 1024 * 1024) { data, error in
                if data != nil {
                    let profileImage = UIImage(data: data!)
                    let user = User(id: uid, username: username, name: name, profileImage: profileImage, following: following, followers: followers)
                    completionHandler(user)
                } else {
                    let user = User(id: uid, username: username, name: name, profileImage: nil, following: following, followers: followers)
                    completionHandler(user)
                }
            }
        }
    }
        
    
    func loadPosts() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments(completion: { query, error in
            if self.posts.count != query?.count {
                for post in query!.documents {
                    self.storage.child("images").child(post.documentID).getData(maxSize: 20 * 1024 * 1024) { imageData, error in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            let title = post.get("title") as! String
                            let postId = post.documentID
                            let subjects = post.get("subjects") as! [String]
                            let date = post.get("date") as! String
                            let uid = post.get("uid") as! String
                            self.loadUser(uid: uid) { user in
                                self.posts.append(Posts(id: postId, image: image!, title: title, subjects: subjects, date: date, user: user!))
                            }
                        }
                    }
                }
            }
        })
    }
    
    func addPost(image: UIImage, title: String, subjects: [String]) {
        
        //Find Date
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        let dateString = dateFormat.string(from: Date())
        
        //Save Post to Firestore
        let dbPosts = Firestore.firestore().collection("posts")
        let dbPostsDoc = dbPosts.addDocument(data: ["title" : title, "subjects": subjects, "uid": self.auth.currentUser!.uid, "date": dateString])
        let postId = dbPostsDoc.documentID
        
        //Save postId to User
        let dbUsers = Firestore.firestore().collection("users").document(auth.currentUser!.uid)
        dbUsers.updateData(["posts": FieldValue.arrayUnion([postId])])
        
        //Save Image to Firebase Storage
        let imageData = image.jpegData(compressionQuality: 1)
        storage.child("images").child(postId).putData(imageData!)
        
    }
    
    func signIn(email: String, password: String) {
        DispatchQueue.main.async {
            self.loading = true
            self.auth.signIn(withEmail: email, password: password) { [weak self] result, error in
                if result != nil && error == nil {
                    self?.signedIn = true
                    self?.loading = false
                }
            }
            
            
        }
    }
    
    
    func signUp(email: String, password: String, name: String, username: String) -> String {
        var errorString: String = ""
        
        self.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if result != nil && error == nil {
                // Save in Firestore
                let db = Firestore.firestore().collection("users").document(self!.auth.currentUser!.uid)
                db.setData(["name": name, "username": username, "posts": [], "followers": [], "following": []])
                
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
        
        self.signedIn = false
    }
    
}

