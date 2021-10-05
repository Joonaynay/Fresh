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
    
    func likePost(currentPost: Post) {
        
        //Save the users current ID to the likes on the post, so we can later get the number of people who have liked the post.
        self.save(collection: "posts", document: currentPost.id, field: "likes", data: [self.currentUser.id])
        
    }
    
    func commentOnPost(currentPost: Post, comment: String) {
        
        //Save comments when someone comments on a post
        save(collection: "posts", document: currentPost.id, field: "comments", data: [comment])
        
    }
    
    func followUser(followUser: User) {
        
        //Save who the user followed
        self.save(collection: "users", document: currentUser.id, field: "following", data: [followUser.id])
        
        //Save that the followed user got followed
        self.save(collection: "users", document: followUser.id, field: "followers", data: [currentUser.id])
        
        //Add to UserModel
        self.currentUser.following.append(followUser.id)
    }
    
    
    func loadUser(uid: String, completion:@escaping (User?) -> Void) {
        
        
        //Check if can load from Core Data
        if let user = cd.fetchUser(uid: uid) {
            for _ in 1...10 {
                print("Loaded User From Core Data")
            }
            
            if let profileImage = self.file.getFromFileManager(name: uid) {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: profileImage, following: user.following!, followers: user.followers! ,posts: nil))
            } else {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: nil, following: user.following!, followers: user.followers! ,posts: nil))
            }
            
        } else {
            
            //Load Firestore doc
            getDoc(collection: "users", id: uid) { doc in
                
                for _ in 1...10 {
                    print("Loaded User From Firebase")
                }
                
                let username = doc?.get("username") as! String
                let name = doc?.get("name") as! String
                let following = doc?.get("following") as! [String]
                let followers = doc?.get("followers") as! [String]
                let posts = doc?.get("posts") as! [String]
                
                //Load Profile Image
                self.loadImage(path: "Profile Images", id: uid) { profileImage in
                    
                    //Create User
                    let user = User(id: uid, username: username, name: name, profileImage: profileImage, following: following, followers: followers, posts: posts)
                    
                    //Return User
                    completion(user)
                }
            }
        }
    }
    
    func loadPosts() {
        
        //Load all Post Firestore Documents
        getDocs(collection: "posts") { query in
            
            //Check if local loaded posts is equal to firebase docs
            if self.posts.count != query?.count {
                
                //Loop through each document and get data
                for post in query!.documents {
                    let title = post.get("title") as! String
                    let postId = post.documentID
                    let subjects = post.get("subjects") as! [String]
                    let date = post.get("date") as! String
                    let uid = post.get("uid") as! String
                    let likes = post.get("likes") as! [String]
                    let comments = post.get("comments") as! [String]
                    
                    //Load user for post
                    self.loadUser(uid: uid) { user in
                        
                        //Load image
                        self.loadImage(path: "images", id: post.documentID) { image in
                            
                            //Add to view model
                            self.posts.append(Post(id: postId, image: image, title: title, subjects: subjects, date: date, user: user!, likes: likes, comments: comments))
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
        let dict = ["title": title, "subjects": subjects, "uid": currentUser.id, "date": dateString, "likes": [], "comments": []] as [String : Any]
        newDoc(collection: "posts", document: nil, data: dict) { postId in
            
            //Save postId to User
            self.save(collection: "users", document: self.currentUser.id, field: "posts", data: [postId!])
            
            //Save to filemanager
            self.file.saveImage(image: image, name: postId!)
            
            //Save Image to Firebase Storage
            self.saveImage(path: "images", file: postId!, image: image)
        }
    }    
}

