//
//  FirebaseStorageModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/27/21.
//

import SwiftUI
import FirebaseStorage

struct FirebaseStorageModel {
    @EnvironmentObject var fb: FirebaseModel
    
    let storage = Storage.storage().reference()
    
    func saveImage(path: String, file: String, image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1)
        storage.child(path).child(file).putData(imageData!)
    }
    
    func loadImage(path: String, id: String, completion:@escaping (UIImage?) -> Void) {
        storage.child(path).child(id).getData(maxSize: 20 * 1024 * 1024) { data, error in
            if error == nil {
                let image = UIImage(data: data!)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
}
