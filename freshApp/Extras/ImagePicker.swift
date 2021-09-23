//
//  ImagePickder.swift
//  The Real Ish
//
//  Created by Wendy Buhler on 9/18/21.
//

import SwiftUI
import MobileCoreServices

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    @Environment(\.presentationMode) var pres
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = .photoLibrary
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            if let uiImage = info[.originalImage] as? UIImage {
                
                let jpegData = uiImage.jpegData(compressionQuality: 0.25)
                let jpegImage = UIImage(data: jpegData!)
                parent.image = jpegImage
                
            }
            
            parent.pres.wrappedValue.dismiss()
        }
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
