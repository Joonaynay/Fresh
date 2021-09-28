//
//  FirebaseModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import Foundation
import FirebaseFirestore

class FirebaseModel: ObservableObject {
    
    let auth = FirebaseAuthModel()
    let storage = FirebaseStorageModel()
    let db = FirestoreModel()
    
    @Published var signedIn = false
    @Published var posts: [Post] = []
    @Published var loading = false
    @Published var currentUser = User(id: "", username: "", name: "", profileImage: nil, following: [], followers: [], posts: [])
    
    init() {
        self.loadUser(uid: auth.loadCurrentUser()) { user in
            self.currentUser = user!
        }
    }
    
    
    
    func followUser(currentUser: User, followUser: User) {
        
        //Save who the user followed
        db.save(collection: "users", document: currentUser.id, field: "following", data: [followUser.id])
        
        //Save that the followedUser got followed
        db.save(collection: "users", document: followUser.id, field: "followers", data: [currentUser.id])
        
        //Add to UserModel
        self.currentUser.following.append(followUser.id)
    }
    
    
    func loadUser(uid: String, completion:@escaping (User?) -> Void) {
        //Load Firestore doc
        db.getDoc(collection: "users", id: uid) { doc in
            let username = doc?.get("username") as! String
            let name = doc?.get("name") as! String
            let following = doc?.get("following") as! [String]
            let followers = doc?.get("followers") as! [String]
            let posts = doc?.get("posts") as! [String]
            
            //Load Profile Image
            self.storage.loadImage(path: "Profile Images", id: self.currentUser.id) { image in
                var profileImage: UIImage?
                if image != nil {
                    profileImage = image
                } else {
                    profileImage = nil
                }
                //Return User
                let user = User(id: uid, username: username, name: name, profileImage: profileImage, following: following, followers: followers, posts: posts)
                completion(user)
            }
        }
    }
    
    
    
    func loadPost(user: User?, postId: String, completion:@escaping (Post?) -> Void) {
        
        //Load Firestore document
        db.getDoc(collection: "posts", id: postId, completion: { doc in
            let title = doc?.get("title") as! String
            let subjects = doc?.get("subjects") as! [String]
            let date = doc?.get("date") as! String
            let uid = doc?.get("uid") as! String
            
            //Load Post Image
            self.storage.loadImage(path: "images", id: postId) { uiImage in
                let image = uiImage!
                
                //Check if need to load user
                if user == nil {
                    self.loadUser(uid: uid) { loadedUser in
                        // Return Post
                        let post = Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: loadedUser!)
                        completion(post)
                    }
                } else {
                    //Return Post
                    let post = Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: user!)
                    completion(post)
                }
            }
        })
        
        
        
    }
    
    
    func loadPosts() {
        
        //Load all Post Firestore Documents
        db.getDocs(collection: "posts") { query in
            
            //Check if local loaded posts is equal to firebase docs
            if self.posts.count != query?.count {
                
                //Loop through each document and get data
                for post in query!.documents {
                    let title = post.get("title") as! String
                    let postId = post.documentID
                    let subjects = post.get("subjects") as! [String]
                    let date = post.get("date") as! String
                    let uid = post.get("uid") as! String
                    
                    //Load Image
                    self.storage.loadImage(path: "images", id: post.documentID) { image in
                        
                        //Load user for post
                        self.loadUser(uid: uid) { user in
                            
                            //Add post to PostModel
                            if image == nil {
                                self.posts.append(Post(id: postId, image: nil, title: title, subjects: subjects, date: date, user: user!))
                            } else {
                                self.posts.append(Post(id: postId, image: image!, title: title, subjects: subjects, date: date, user: user!))
                            }                            
                        }
                    }
                }
            }
        }
    }
    
    func addPost(image: UIImage, title: String, subjects: [String]) {
        
        //Find Date
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        let dateString = dateFormat.string(from: Date())
        
        //Save Post to Firestore
        let dict = ["title": title, "subjects": subjects, "uid": currentUser.id, "date": dateString] as [String : Any]
        db.newDoc(collection: "posts", document: nil, data: dict) { postId in
            
            //Save postId to User
            self.db.save(collection: "users", document: self.currentUser.id, field: "posts", data: [postId!])
            
            //Save Image to Firebase Storage
            self.storage.saveImage(path: "images", file: postId!, image: image)
        }
    }    
}

