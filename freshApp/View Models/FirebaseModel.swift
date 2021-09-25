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
    let auth = Auth.auth()
    let storage = Storage.storage().reference()
    
    
    
    func addProfilePicture(image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1)
        storage.child("Profile Images").child(auth.currentUser!.uid).putData(imageData!)
    }
    
    
    func loadPosts() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments(completion: { query, error in
            if self.posts.count != query?.count {
                for post in query!.documents {
                    self.storage.child("images").child(post.documentID).getData(maxSize: 20 * 1024 * 1024) { imageData, error in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            let caption = post.get("caption") as! String
                            let postId = post.documentID
                            let subjects = post.get("subjects") as! [String]
                            let date = post.get("date") as! String
                            let uid = post.get("uid") as! String
                            db.collection("users").document(uid).getDocument { doc, error in
                                let username = doc?.get("username") as! String
                                self.storage.child("Profile Images").child(uid).getData(maxSize: 20 * 1024 * 1024) { data, error in
                                    if error != nil {
                                        self.posts.append(Posts(id: postId, image: image!, caption: caption, subjects: subjects, date: date, username: username, uid: uid, profileImage: UIImage(systemName: "person.circle.fill")!))
                                    } else {
                                        let profileImage = UIImage(data: data!)
                                        self.posts.append(Posts(id: postId, image: image!, caption: caption, subjects: subjects, date: date, username: username, uid: uid, profileImage: profileImage!))
                                    }
                                }
                            }                            
                        }
                    }
                }
            }
        })
    }
    
    func addPost(image: UIImage, caption: String, subjects: [String]) {
        
        //Find Date
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        let dateString = dateFormat.string(from: Date())
        
        //Save Post to Firestore
        let dbPosts = Firestore.firestore().collection("posts")
        let dbPostsDoc = dbPosts.addDocument(data: ["caption" : caption, "subjects": subjects, "uid": self.auth.currentUser!.uid, "date": dateString])
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
                db.setData(["name": name, "username": username, "posts": []])
                
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

