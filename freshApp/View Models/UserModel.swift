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
    let profileImage: UIImage?
    //let followedUsers: [String]
}
