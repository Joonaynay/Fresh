//
//  HomePostView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct HomePostView: View {
    
    var subject: String
    
    var body: some View {
        Text(subject)
    }
}

struct HomePostView_Previews: PreviewProvider {
    static var previews: some View {
        HomePostView(subject: "Business")
    }
}
