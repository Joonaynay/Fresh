//
//  UserModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
 
struct User: Identifiable {
    let id: String
    let username: String
    let name: String
    var profileImage: UIImage?
    var following: [String]
    var followers: [String]
    var numFollowers: Int
    var numFollowing: Int
    let posts: [String]?
}
