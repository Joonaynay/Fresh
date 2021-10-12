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
    
    func loadProfilePosts(user: User) {
        getDocs(collection: "posts") { query in
            let group = DispatchGroup()
            var loadedPosts = [Post]()
            for doc in query!.documents {
                group.enter()
                let title = doc.get("title") as! String
                let postId = doc.documentID
                let date = doc.get("date") as! String
                let likes = doc.get("likes") as! [String]
                self.loadImage(path: "images", id: postId) { image in
                    self.loadMovie(path: "videos", file: "\(postId).m4v") { movie in
                        if let movie = movie {
                            loadedPosts.append(Post(id: postId, image: image!, title: title, subjects: [], date: date, user: user, likes: likes, comments: nil, movie: movie))
                        }
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                let index = self.users.firstIndex { userIndex in
                    userIndex.id == user.id
                }
                if let index = index {
                    var user = self.users[index]
                    user.posts = loadedPosts
                }
                self.posts.append(contentsOf: loadedPosts)
            }
        }
    }
    
    func loadFollowingPosts() {
        self.loading = true
        
        //Load all Post Firestore Documents
        getDocs(collection: "posts") { query in
            
            //Check if local loaded posts is equal to firebase docs
            if self.posts.count != query?.count {
                
                let group = DispatchGroup()
                //Loop through each document and get data
                var loadedPosts = [Post]()
                for post in query!.documents {
                    group.enter()
                    let title = post.get("title") as! String
                    let postId = post.documentID
                    let subjects = post.get("subjects") as! [String]
                    let date = post.get("date") as! String
                    let uid = post.get("uid") as! String
                    let likes = post.get("likes") as! [String]
                    
                    if self.currentUser.following.contains(uid) {
                        //Load user for post
                        self.loadConservativeUser(uid: uid) { user in
                            
                            //Load image
                            self.loadImage(path: "images", id: post.documentID) { image in
                                
                                //Load Movie
                                self.loadMovie(path: "videos", file: "\(post.documentID).m4v") { url in
                                    //Add to view model
                                    
                                    if let image = image, let url = url {
                                        loadedPosts.append(Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: user!, likes: likes, movie: url))
                                    }
                                    group.leave()
                                }
                            }
                        }
                    } else {
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self.posts.append(contentsOf: loadedPosts)
                    self.loading = false
                }
            } else {
                self.loading = false
            }
        }
        
    }
    
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
                            } else {
                                completion(nil)
                            }
                        }
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    func loadPosts() {
        
        self.loading = true
        
        //Load all Post Firestore Documents
        getDocs(collection: "posts") { query in
            
            //Check if local loaded posts is equal to firebase docs
            if self.posts.count != query?.count {
                
                let group = DispatchGroup()
                //Loop through each document and get data
                var posts = [Post]()
                for post in query!.documents {
                    group.enter()
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
                                    posts.append(Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: user!, likes: likes, movie: url))
                                }
                                group.leave()
                            }
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.posts = posts
                    self.loading = false
                }
            } else {
                self.loading = false
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
