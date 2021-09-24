//
//  LoadingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/23/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color.theme.secondaryText.opacity(0.35))
            ProgressView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
