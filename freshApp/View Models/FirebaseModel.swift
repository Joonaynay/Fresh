//
//  FirebaseModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseModel: ObservableObject {
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let file = FileManagerModel()
    lazy var cd = Persistence()
    
    @Published var signedIn = false
    @Published var posts: [Post] = []
    @Published var loading = false
    @Published var currentUser = User(id: "", username: "", name: "", profileImage: nil, following: [], followers: [], posts: nil)
    
    init() {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            self.loadUser(uid: uid) { user in
                if let user = user {
                    self.currentUser = user
                }
            }
        }
    }
    
    func search(string: String, completion:@escaping ([Post]?) -> Void) {
        
        // Lowcase the string
        let lowString = string.lowercased()
        
        // Start loading
        self.loading = true
        

        //Load all documents
        self.getDocs(collection: "posts") { query in
            
            var postsArray = [Post]()
            let group = DispatchGroup()
            for f in query!.documents {
                group.enter()
                self.loadPost(postId: f.documentID, completion: { post in
                    if let p = post {
                        postsArray.append(p)
                    }
                    group.leave()
                })
            }
            group.notify(queue: .main, execute: {
                completion(postsArray)
            })
        }
    }
}

