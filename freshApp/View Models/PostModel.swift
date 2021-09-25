//
//  PostModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct Posts: Identifiable {
    var id: String
    var image: UIImage
    var caption: String
    var subjects: [String]
    var date: String
    var username: String
    var uid: String
    var profileImage: UIImage
}
