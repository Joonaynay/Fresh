//
//  StorageModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/28/21.
//

import SwiftUI
import FirebaseStorage

extension FirebaseModel {
    
    func saveImage(path: String, file: String, image: UIImage) {
        //Convert UIImage to Data
        let imageData = image.jpegData(compressionQuality: 1)
        
        //Save data to FirebaseStorage
        storage.child(path).child(file).putData(imageData!)
    }
    
    func loadImage(path: String, id: String, completion:@escaping (UIImage?) -> Void) {
        
        //Check if image is already saved in filemanager
        if let image = file.getFromFileManager(name: id) {
            completion(image)
        } else {
            
            //Load Image Data from Firebase
            storage.child(path).child(id).getData(maxSize: 20 * 1024 * 1024) { data, error in
                
                //Check for error
                if error == nil {
                    
                    //Convert data to UIImage then return the image
                    let image = UIImage(data: data!)
                    completion(image)
                } else {
                    
                    //Return Nil
                    completion(nil)
                }
            }
        }
    }
}
