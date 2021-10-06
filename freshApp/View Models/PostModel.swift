//
//  PostModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct Post: Identifiable {
    var id: String
    var image: UIImage?
    var title: String
    var subjects: [String]
    var date: String
    var user: User
    var likes: [String]
    var comments: [String]
    var movie: URL?
}
