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
    private let subjects = Bundle.main.decode([SubjectsModel].self, from: "subjects.json")
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                TitleBarView(title: "Subjects")
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
        }
        .navigationBarHidden(true)
    }
}

struct HomePostView: View {
    
    @Binding var subject: SubjectsModel
    
    @State var selection: String? = ""
    @State var profileView = "profileView"
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                TitleBarView(title: subject.name)
                    .onTapGesture {
                        subject.name = ""
                    }
                ScrollView {
                    VStack {
                        ForEach(fb.posts) { post in
                            if post.subjects.contains(subject.name) {
                                
                                Image(uiImage: post.image!)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text("Username: \(post.caption)")
                                        .multilineTextAlignment(.leading)
                                        .font(.title3)
                                }.padding(25)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
