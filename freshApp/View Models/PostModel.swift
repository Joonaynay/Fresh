//
//  PostModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import Firebase

struct Post: Identifiable {
    var id: String
    var image: UIImage
    var title: String
    var subjects: [String]
    var date: String
    var user: User
    var likes: [String]
    var comments: [Comment]?
    var movie: URL
}


extension FirebaseModel {
    
    func loadPost(postId: String, completion:@escaping (Post?) -> Void) {
        //Load Post Firestore Document
        getDoc(collection: "posts", id: postId) { document in
            
            
            if let doc = document {
                //Check if local loaded posts is equal to firebase docs
                //Loop through each document and get data
                let title = doc.get("title") as! String
                let postId = doc.documentID
                let subjects = doc.get("subjects") as! [String]
                let date = doc.get("date") as! String
                let uid = doc.get("uid") as! String
                let likes = doc.get("likes") as! [String]
                
                //Load user for post
                self.loadConservativeUser(uid: uid) { user in
                    
                    //Load image
                    self.loadImage(path: "images", id: doc.documentID) { image in
                        
                        //Load Movie
                        self.loadMovie(path: "videos", file: "\(doc.documentID).m4v") { url in
                            //Add to view model
                            
                            if let image = image, let url = url {
                                let post = (Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: user!, likes: likes, movie: url))
                                completion(post)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func loadPosts() {
        
        //Load all Post Firestore Documents
        getDocs(collection: "posts") { query in
            
            //Check if local loaded posts is equal to firebase docs
            if self.posts.count != query?.count {
                
//                var loadedPosts: [Post] = []
                
                //Loop through each document and get data
                for post in query!.documents {
                    let title = post.get("title") as! String
                    let postId = post.documentID
                    let subjects = post.get("subjects") as! [String]
                    let date = post.get("date") as! String
                    let uid = post.get("uid") as! String
                    let likes = post.get("likes") as! [String]
                    
                    //Load user for post
                    self.loadConservativeUser(uid: uid) { user in
                        
                        //Load image
                        self.loadImage(path: "images", id: post.documentID) { image in
                            
                            //Load Movie
                            self.loadMovie(path: "videos", file: "\(post.documentID).m4v") { url in
                                //Add to view model
                                
                                if let image = image, let url = url {
                                    self.posts.append(Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: user!, likes: likes, movie: url))
                                }
                            }
                        }
                    }
//                    if post == query?.documents.last {
//                        self.posts = loadedPosts
//                    }
                }
            }
        }
    }
    
    func addPost(image: UIImage, title: String, subjects: [String], movie: URL) {
        
        //Find Date
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        let dateString = dateFormat.string(from: Date())
        
        //Save Post to Firestore
        let dict = ["title": title, "subjects": subjects, "uid": currentUser.id, "date": dateString, "likes": []] as [String : Any]
        newDoc(collection: "posts", document: nil, data: dict) { postId in
            
            //Save postId to User
            self.save(collection: "users", document: self.currentUser.id, field: "posts", data: [postId!])
            
            //Save to filemanager
            self.file.saveImage(image: image, name: postId!)
            
            //Save Image to Firebase Storage
            self.saveImage(path: "images", file: postId!, image: image)
            
            //Save movie to Firestore
            self.saveMovie(path: "videos", file: postId!, url: movie)
        }
    }
    
    func likePost(currentPost: Post) {
        
        if !currentPost.likes.contains(currentUser.id) {
            //Save the users current ID to the likes on the post, so we can later get the number of people who have liked the post.
            self.save(collection: "posts", document: currentPost.id, field: "likes", data: [self.currentUser.id])
        } else {
            db.collection("posts").document(currentPost.id).updateData(["likes": FieldValue.arrayRemove([currentUser.id])])
        }
    }
}
