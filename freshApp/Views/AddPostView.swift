//
//  AddPostView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct AddPostView: View {
    
    @State private var caption: String = ""
    @State private var showImages: Bool = false
    @State var image: UIImage?
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            ScrollView {
                Text("Add A Post")
                    .font(.largeTitle)
                    .foregroundColor(Color.theme.accent)
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
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 1.05, height: UIScreen.main.bounds.width / 1.05)
                }
                TextEditor(text: $caption)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.theme.secondaryText)
                    .foregroundColor(Color.theme.accent)
                
                NavigationLink(
                    destination: SelectSubjectView(image: image),
                    label: {
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
            .padding()
            .sheet(isPresented: $showImages, content: {
                ImagePickerView(image: $image)
            })
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSubjectView()
            .preferredColorScheme(.dark)
    }
}



struct SelectSubjectView: View {
    
    var image: UIImage?
    private let subjects = Bundle.main.decode([SubjectsModel].self, from: "subject.json")
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Select up to 3 subjects that your post corresponds with.")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    ForEach(subjects) { subject in
                        checkMarkSubjects(subject: subject)
                    }
                }
            }
        }
    }
}


struct checkMarkSubjects : View {
    
    @State var checkMark: Bool = false
    let subject: SubjectsModel
    
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
            checkMark.toggle()
        }
    }
}
