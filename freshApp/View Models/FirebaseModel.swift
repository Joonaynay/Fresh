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
        
        if !currentPost.likes.contains(currentUser.id) {
            //Save the users current ID to the likes on the post, so we can later get the number of people who have liked the post.
            self.save(collection: "posts", document: currentPost.id, field: "likes", data: [self.currentUser.id])
        } else {
            db.collection("posts").document(currentPost.id).updateData(["likes": FieldValue.arrayRemove([currentUser.id])])
        }
    }
    
    
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
    
    func followUser(followUser: User) {
        if !followUser.followers!.contains(currentUser.id) {
            //Save who the user followed
            self.save(collection: "users", document: currentUser.id, field: "following", data: [followUser.id])
            
            //Save that the followed user got followed
            self.save(collection: "users", document: followUser.id, field: "followers", data: [currentUser.id])
            
            //Add to UserModel
            
            self.currentUser.following!.append(followUser.id)
            
            //Save to core data
            let coreUser = cd.fetchUser(uid: currentUser.id)
            coreUser?.following?.append(followUser.id)
            cd.save()
            
        } else {
            db.collection("users").document(followUser.id).updateData(["followers": FieldValue.arrayRemove([currentUser.id])])
            db.collection("users").document(currentUser.id).updateData(["following": FieldValue.arrayRemove([followUser.id])])
            
            // Delete from UserModel
            let index = currentUser.following?.firstIndex(of: followUser.id)
            currentUser.following?.remove(at: index!)
            
            //Save to core data
            let deleteCoreUser = cd.fetchUser(uid: currentUser.id)
            let newIndex = deleteCoreUser?.following?.firstIndex(of: followUser.id)
            deleteCoreUser?.following?.remove(at: newIndex!)
            cd.save()
            
        }
        
    }
    
    func loadConservativeUser(uid: String, completion:@escaping (User?) -> Void) {
        
        //Check if can load from Core Data
        if let user = cd.fetchUser(uid: uid) {
            for _ in 1...10 {
                print("Loaded User From Core Data")
            }
            
            if let profileImage = self.file.getFromFileManager(name: uid) {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: profileImage, following: user.following!, followers: user.followers!, posts: nil))
            } else {
                completion(User(id: user.id!, username: user.username!, name: user.name!, profileImage: nil, following: user.following!, followers: user.followers!, posts: nil))
            }
            
        } else {
            
            //Load Firestore doc
            getDoc(collection: "users", id: uid) { doc in
                
                for _ in 1...10 {
                    print("Loaded User From Firebase")
                }
                
                let username = doc?.get("username") as! String
                
                //Load Profile Image
                self.loadImage(path: "Profile Images", id: uid) { profileImage in
                    
                    //Core Data
                    
                    
                    //Create User
                    let user = User(id: uid, username: username, name: nil, profileImage: profileImage, following: nil, followers: nil, posts: nil)
                    
                    //Return User
                    completion(user)
                }
            }
        }
        
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
                    
                    //Core Data
                    
                    
                    //Create User
                    let user = User(id: uid, username: username, name: name, profileImage: profileImage, following: following, followers: followers, posts: posts)
                    
                    //Return User
                    completion(user)
                }
            }
        }
    }
    
    func loadPosts() {
        self.loading = true
        
        //Load all Post Firestore Documents
        getDocs(collection: "posts") { query in
            
            //Check if local loaded posts is equal to firebase docs
            if self.posts.count != query?.documents.count {
                
                //Loop through each document and get data
                for post in query!.documents {
                    let title = post.get("title") as! String
                    let postId = post.documentID
                    let subjects = post.get("subjects") as! [String]
                    let date = post.get("date") as! String
                    let uid = post.get("uid") as! String
                    let likes = post.get("likes") as! [String]
                    
                    //Load user for post
                    self.loadUser(uid: uid) { user in
                        
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
                }
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
}

