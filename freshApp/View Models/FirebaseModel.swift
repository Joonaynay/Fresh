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
    let auth = Auth.auth()
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    
    
    
    func loadPosts() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments(completion: { query, error in
            if self.posts.count != query?.count {
                for post in query!.documents {
                    let storage = Storage.storage().reference().child("images")
                    storage.child(post.documentID).getData(maxSize: 20 * 1024 * 1024) { imageData, error in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            self.posts.append(Posts(id: post.documentID, image: image, caption: post.get("caption") as! String, subjects: post.get("subjects") as! [String]))
                        }
                    }
                }
            }
        })
    }
    
    func addPost(image: UIImage, caption: String, subjects: [String]) {
        let db = Firestore.firestore().collection("posts").addDocument(data: ["caption" : caption, "subjects": subjects, "uid": self.auth.currentUser!.uid])
        let postId = db.documentID
        let imageData = image.jpegData(compressionQuality: 1)
        let storage = Storage.storage().reference()
        storage.child("images").child(postId).putData(imageData!)
        self.posts.append(Posts(id: postId, image: image, caption: caption, subjects: subjects))
        
        
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                
            } else {
                // Success
                DispatchQueue.main.async {
                    self?.signedIn = true
                }
            }
            
            
        }
    }
    
    func signInWithGoogle(email: String, password: String) {
        
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.signedIn = true
                Firestore.firestore().collection("users").document(self!.auth.currentUser!.uid).setData(["firstName": firstName, "lastName": lastName])
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

