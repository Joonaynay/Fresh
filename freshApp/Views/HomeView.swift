//
//  HomeView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI


struct HomeView: View {
    
    @State var subject = SubjectsModel(id: 0, name: "", image: "")
    
    var body: some View {
        if subject.name == "" {
            SubjectSelectView(subject: $subject)
        } else {
            HomePostView(subject: $subject)
        }
    }
    
}


struct SubjectSelectView: View {
    
    @Binding var subject: SubjectsModel
    @State var selection: String? = ""
    private let profileView = "profileView"
    private let subjects = Bundle.main.decode([SubjectsModel].self, from: "subjects.json")
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Subjects")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                    Menu {
                        Button("View Profile") { selection = profileView }
                    } label: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                            .padding()
                    }
                    
                    
                }
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(Color.theme.secondaryText)
                ScrollView() {
                    LazyVGrid(columns: [GridItem(spacing: 10), GridItem(spacing: 10)], spacing: 10, content: {
                        ForEach(subjects) { subject in
                            Button(action: {
                                self.subject = subject
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(height: 75)
                                        .foregroundColor(Color.theme.pinkColor)
                                    VStack {
                                        Image(systemName: subject.image)
                                        Text(subject.name)
                                    }
                                }
                            })
                        }
                    })
                    .padding(.horizontal, 10)
                }
            }
            NavigationLink(destination: ProfileView(), tag: profileView, selection: $selection, label: {})
            
        }
        .navigationBarHidden(true)
    }
}

struct HomePostView: View {
    
    @Binding var subject: SubjectsModel
    
    var body: some View {
        HStack {
            Text(subject.name)
                .navigationBarHidden(true)
                .onTapGesture {
                    subject.name = ""
                }
            Image(systemName: subject.image)
        }
        
    }
}
