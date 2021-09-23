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
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                }
                TextEditor(text: $caption)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.theme.secondaryText)
                    .foregroundColor(Color.theme.accent)
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
        AddPostView()
    }
}
