//
//  HomeView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct HomeView: View {
    
    
    @State var destination = ""
    @State private var selection: String? = ""
    
    @State private var subject = ""
    private let homepostview = "homepostview"
    private let subjects = SubjectsModel()
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: HomePostView(subject: subject),
                    tag: homepostview,
                    selection: $selection,
                    label: {})
                Color.theme.background
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        ForEach(subjects.list, id: \.self) { subject in
                            Button(action: {
                                self.subject = subject
                                selection = homepostview
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 100)
                                        .foregroundColor(Color.theme.pinkColor)
                                    Text(subject)
                                }
                            }) // Button
                        } // ForEach
                    } // VStack
                } // ScrollView
                .navigationTitle("Subjects")
            } // ZStack
        } // NavigationView
    } // Body
} // View



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
