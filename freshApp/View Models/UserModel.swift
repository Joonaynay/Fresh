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
    var following: [String]
    var followers: [String]
}
