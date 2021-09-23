//
//  SearchView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct SearchView: View {
    
    @State var selection: String? = ""
    @State var profileView = "profileView"
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TitleBarView(title: "Trending")
                ScrollView {}
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
