//
//  HomeView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct HomeView: View {
    
    let subjects = SubjectsModel()
    
    var body: some View {
        ForEach(subjects.list, id: \.self) { subject in
            Text(subject)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
