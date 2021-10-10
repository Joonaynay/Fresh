//
//  Comment.swift
//  freshApp
//
//  Created by Forrest Buhler on 10/5/21.
//

import Foundation

struct Comment: Identifiable {
    var id = UUID()
    var text: String
    var user: User    
}

extension FirebaseModel {
    func commentOnPost(currentPost: Post, comment: String) {
        
        //Save comments when someone comments on a post
        self.saveDeep(collection: "posts", collection2: "comments", document: currentPost.id, document2: currentUser.id, field: "comments", data: [comment])
        
    }
    
    func loadComments(currentPost: Post, completion:@escaping ([Comment]?) -> Void) {
        self.getDocsDeep(collection: "posts", document: currentPost.id, collection2: "comments") { documents in
            
            
            if let documents = documents {
                var list: [Comment] = []
                
                for doc in documents.documents {
                    let comments = doc.get("comments") as! [String]
                    self.loadConservativeUser(uid: doc.documentID) { user in
                        if let user = user {
                            for comment in comments {
                                list.append(Comment(text: comment, user: user))
                                if comment == comments.last {
                                    completion(list)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
