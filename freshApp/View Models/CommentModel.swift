//
//  Comment.swift
//  freshApp
//
//  Created by Forrest Buhler on 10/5/21.
//

import Foundation

struct Comment: Identifiable {
    var id = UUID()
    var text: String
    var user: User    
}
