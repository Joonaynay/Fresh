//
//  AddPostView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI
import AVKit

struct AddPostView: View {
    
    @State private var title: String = ""
    @State private var showImages: Bool = false
    @State private var showVideos: Bool = false
    @State var image: UIImage?
    @State var movie: URL?
    
    @State private var nextDisabled: Bool = true
    
    @State private var selection: String? = ""
    let subjectsTag = "subjects"
    
    @State var dissmissView: Bool = false
    @Environment(\.presentationMode) var pres
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                
                HStack {
                    Text("New Post")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                    Button("Cancel") { pres.wrappedValue.dismiss() }
                        .padding()
                }
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(Color.theme.lineColor)
                
                ScrollView(showsIndicators: false) {
                    VStack() {
                        TextField("Title...", text: $title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding(.horizontal)
                            .background(Color.theme.secondaryText)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Button(action: { showImages.toggle() }, label: {
                            Text("Select a thumbnail...")
                                .font(.headline)
                                .foregroundColor(Color.theme.blueTextColor)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.blueColor)
                                .padding(.horizontal)
                                .padding(.top)
                            
                        })
                        if image != nil {
                            Image(uiImage: image!)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width / 1.09, height: (UIScreen.main.bounds.width / 1.09) * 9/16)
                                .padding(.top)
                        } else {
                            Color.theme.background
                                .frame(width: UIScreen.main.bounds.width / 1.09, height: (UIScreen.main.bounds.width / 1.09) * 9/16)
                                .padding(.top)
                        }
                        Button(action: { showVideos.toggle() }, label: {
                            Text("Select a video...")
                                .font(.headline)
                                .foregroundColor(Color.theme.blueTextColor)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.blueColor)
                                .padding(.horizontal)
                            
                        })
                        .padding(.top)
                        if movie != nil {
                            VideoPlayer(player: AVPlayer(url: movie!))
                                .frame(width: UIScreen.main.bounds.width / 1.09, height: (UIScreen.main.bounds.width / 1.09) * 9/16)
                        } else {
                            Color.theme.background
                                .frame(width: UIScreen.main.bounds.width / 1.09, height: (UIScreen.main.bounds.width / 1.09) * 9/16)
                                .padding(.top)
                        }
                    }
                    
                    Button(action: { selection = subjectsTag }, label: {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(nextDisabled ? Color(.systemGray2) : Color.theme.blueTextColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(nextDisabled ? Color(.systemGray3) : Color.theme.blueColor)
                            .padding(.horizontal)
                            .padding(.vertical)
                    }).disabled(nextDisabled)
                    .onChange(of: (image == nil || movie == nil || title.isEmpty), perform: { _ in
                        if image != nil && movie != nil && !title.isEmpty {
                            nextDisabled = false
                        }
                    })
                }
                .sheet(isPresented: $showImages, content: {
                    ImagePickerView(image: $image, movie: .constant(nil), mediaTypes: ["public.image"])
                })
                .sheet(isPresented: $showVideos, content: {
                    ImagePickerView(image: .constant(nil), movie: $movie, mediaTypes: ["public.movie"])
                })
            }
            NavigationLink(
                destination: SelectSubjectView(image: image, movie: movie, title: title, dissmissView: $dissmissView),
                tag: subjectsTag,
                selection: $selection,
                label: {})
            
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        .navigationBarHidden(true)
        .onAppear() {
            if dissmissView {
                pres.wrappedValue.dismiss()
            }
        }
    }
}

struct SelectSubjectView: View {
    
    let image: UIImage?
    let movie: URL?
    private let subjects = Bundle.main.decode([SubjectsModel].self, from: "subjects.json")
    @State var list: [String] = []
    private let trendingViewTag = "profileView"
    @State private var selection: String? = ""
    @State private var buttonDisabled: Bool = true
    let title: String
    
    @Binding var dissmissView: Bool
    @Environment(\.presentationMode) var pres
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text("Select up to 3 subjects that your post corresponds with.")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                ScrollView(showsIndicators: false) {
                    ForEach(subjects) { subject in
                        checkMarkSubjects(subject: subject, list: $list, buttonDisabled: $buttonDisabled)
                    }
                }
                Button(action: {
                    if let image = image, let movie = movie {
                        fb.addPost(image: image, title: title, subjects: list, movie: movie)
                    }
                    dissmissView = true
                    pres.wrappedValue.dismiss()
                }, label: {
                    Text("Post")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.theme.blueTextColor)
                        .background(Color.theme.blueColor)
                })
                .disabled(buttonDisabled)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}


struct checkMarkSubjects : View {
    
    @State var checkMark: Bool = false
    let subject: SubjectsModel
    @Binding var list: [String]
    @Binding var buttonDisabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: checkMark ? "checkmark.square" : "square")
            Text(subject.name)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 75)
        .padding(.horizontal, 35)
        .background(Color.theme.background)
        .foregroundColor(Color.theme.accentColor)
        .onTapGesture {
            if list.count != 3 {
                if !checkMark {
                    list.append(subject.name)
                } else {
                    list.removeAll(where: { $0 == subject.name })
                }
                if (list.count > 0) && (list.count <= 3) {
                    buttonDisabled = false
                } else {
                    buttonDisabled = true
                }
                checkMark.toggle()
            } else {
                checkMark = false
                list.removeAll(where: { $0 == subject.name })
            }
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSubjectView(image: UIImage(contentsOfFile: "Logo.png")!, movie: URL(fileURLWithPath: ""), title: "Sup", dissmissView: .constant(false))
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
