//
//  HomeView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI


struct HomeView: View {
    
    @State var subject = SubjectsModel(id: 0, name: "", image: "")
    
    @EnvironmentObject private var vm: SearchBar
    
    
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
    
    @EnvironmentObject private var vm: SearchBar
    
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                TitleBarView(title: "Subjects")
                SearchBarView(textFieldText: $vm.AllDataSearchText)              
                ScrollView() {
                    LazyVGrid(columns: [GridItem(spacing: 10), GridItem(spacing: 10)], spacing: 10, content: {
                        ForEach(vm.filteredData) { subject in
                            Button(action: {
                                self.subject = subject
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(height: 75)
                                        .foregroundColor(Color.theme.blueColor)
                                    VStack {
                                        Image(systemName: subject.image)
                                        Text(subject.name)
                                    }
                                    .foregroundColor(Color.theme.blueTextColor)
                                }
                            })
                        }
                    })
                    .padding(.horizontal, 15)
                }
            }
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )

        .navigationBarHidden(true)
    }
}

struct HomePostView: View {
    
    @Binding var subject: SubjectsModel
    
    @State var selection: String? = ""
    @State var profileView = "profileView"
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: { subject.name = "" }, label: {
                        Image(systemName: "chevron.left")
                            .font(Font.headline.weight(.bold))
                    })
                    .padding(.leading)
                    TitleBarView(title: subject.name)
                }
                
                ScrollView {
                    Button(action: { fb.loadPosts() }, label: {
                        Text("Load")
                    })
                    VStack {
                        ForEach(fb.posts) { post in
                            if post.subjects.contains(subject.name) {
                                PostView(post: post)
                            }
                        }
                    }
                }
            }
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        .navigationBarHidden(true)
    }
}
