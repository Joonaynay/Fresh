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
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Text("Subjects")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                    NavigationLink(
                        destination: ProfileView(),
                        label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                                .padding()
                        })
                }
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(subjects.list, id: \.self) { subject in
                            Button(action: {
                                self.subject = subject
                                selection = homepostview
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 115)
                                        .foregroundColor(Color.theme.pinkColor)
                                    
                                    Text(subject)
                                }
                            })
                        }
                    }
                }
            }
            NavigationLink(
                destination: HomePostView(subject: subject),
                tag: homepostview,
                selection: $selection,
                label: {})
                
                .navigationBarTitle("Subjects")
                .navigationBarHidden(true)
            
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}
