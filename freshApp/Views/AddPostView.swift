//
//  AddPostView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct AddPostView: View {
    
    @State private var title: String = ""
    @State private var showImages: Bool = false
    @State var image: UIImage?
    
    @State var dissmissView: Bool = false
    @Environment(\.presentationMode) var pres
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
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
                    .foregroundColor(Color.theme.secondaryText)
                
                ScrollView() {
                    Button(action: { showImages.toggle() }, label: {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(Color.theme.pinkColor)
                            .overlay(
                                Text("Select an image...")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                                                )
                    })
                    .padding(.top)

                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 1.05, height: UIScreen.main.bounds.width / 1.05)
                    }
                    TextEditor(text: $title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.theme.secondaryText)
                        .foregroundColor(Color.theme.accent)
                    
                    if image != nil {
                        NavigationLink(destination: SelectSubjectView(image: image!, title: title, dissmissView: $dissmissView), label: {
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundColor(Color.theme.pinkColor)
                                .overlay(
                                    Text("Next")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                )
                        })
                    }
                }
                .sheet(isPresented: $showImages, content: {
                    ImagePickerView(image: $image)
                })
            }
        }
        .onAppear() {
            if dissmissView {
                pres.wrappedValue.dismiss()
            }
        }
    }
}

struct SelectSubjectView: View {
    
    let image: UIImage
    private let subjects = Bundle.main.decode([SubjectsModel].self, from: "subjects.json")
    @State var list: [String] = []
    private let trendingViewTag = "profileView"
    @State private var selection: String? = ""
    @State private var buttonDisabled: Bool = true
    let title: String
    
    @Binding var dissmissView: Bool
    @Environment(\.presentationMode) var pres
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
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
                    fb.addPost(image: image, title: title, subjects: list)
                    dissmissView = true
                    pres.wrappedValue.dismiss()
                }, label: {
                    Text("Post")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.pinkColor)
                })
                .disabled(buttonDisabled)
            }
            .padding()
        }
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
        .background(Color.theme.sheetColor)
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
        SelectSubjectView(image: UIImage(contentsOfFile: "Logo.png")!, title: "Sup", dissmissView: .constant(false))
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
