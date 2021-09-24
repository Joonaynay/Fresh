//
//  TrendingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct TrendingView: View {
    
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

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
