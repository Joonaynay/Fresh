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
    @Published var loading: Bool = false
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
    
    
    func search(string: String, completion:@escaping ([Post]) -> Void) {
        
        DispatchQueue.main.async {
            // Start loading
            self.loading = true
            
            
            let group = DispatchGroup()
            //Load all documents
            self.getDocs(collection: "posts") { query in
                
                var postsArray = [Post]()
                
                for doc in query!.documents {
                    
                    group.enter()
                    var postId = ""
                    let title = doc.get("title") as! String
                    if title.lowercased().contains(string.lowercased()) {
                        postId = doc.documentID
                    }
                    
                    self.loadPost(postId: postId, completion: { post in
                        if let p = post {
                            postsArray.append(p)
                        }
                        
                        group.leave()
                    })
                }
                group.notify(queue: .main, execute: {
                    self.loading = false
                    completion(postsArray)
                })
                
            }
        }
    }    
    
    
}

