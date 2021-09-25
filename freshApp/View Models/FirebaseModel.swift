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
        
        let dbPosts = Firestore.firestore().collection("posts").addDocument(data: ["caption" : caption, "subjects": subjects, "uid": self.auth.currentUser!.uid])
        let postId = dbPosts.documentID
        let dbUsers = Firestore.firestore().collection("users").document(auth.currentUser!.uid)
        dbUsers.updateData(["posts": FieldValue.arrayUnion([postId])])
        let imageData = image.jpegData(compressionQuality: 1)
        let storage = Storage.storage().reference()
        storage.child("images").child(postId).putData(imageData!)
        self.posts.append(Posts(id: postId, image: image, caption: caption, subjects: subjects))
        
        
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
        
        DispatchQueue.main.async {
            
        }
        self.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if result != nil && error == nil {
                self?.signedIn = true
                let changeRequest = self!.auth.currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { error in })
                let db = Firestore.firestore().collection("users").document(self!.auth.currentUser!.uid)
                db.setData(["name": name, "posts": []])
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

