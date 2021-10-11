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
                ScrollView(showsIndicators: false) {
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
    
    @State private var offSetY: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                TitleBarView(title: "   \(subject.name)")
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(fb.posts) { post in
                            if post.subjects.contains(subject.name) {
                                PostView(post: post)
                            }
                        }
                    }
                }
                .offset(y: offSetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            if value.translation.height > 0 {
                                offSetY = value.translation.height
                            }

                            if offSetY >= 15 && fb.loading == false {
                                fb.loadPosts()
                                offSetY = 0
                            }
                            offSetY = 0
                        })
                        .onEnded({ value in
                            offSetY = 0
                        })
                )
            }
            Button(action: { subject.name = "" }, label: {
                Image(systemName: "chevron.left")
                    .font(Font.headline.weight(.bold))
            })
            .padding(.top, 30)
            .padding(.leading)
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
