//
//  StorageModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/28/21.
//

import SwiftUI
import FirebaseStorage

extension FirebaseModel {
    
    func saveMovie(path: String, file: String, url: URL) {
        //Convert url to Data
        do {
            let movieData = try Data(contentsOf: url)
            storage.child(path).child("\(file).m4v").putData(movieData)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
    }
    
    func loadMovie(path: String, file: String, completion:@escaping (URL?) -> Void) {
        storage.child(path).child(file).downloadURL { url, error in
            if error == nil {
                completion(url)
            }
        }
    }
    
    func saveImage(path: String, file: String, image: UIImage) {
        if path == "Profile Images" {
            //Convert UIImage to Data
            let imageData = image.jpegData(compressionQuality: 0.25)
            //Save data to FirebaseStorage
            storage.child(path).child(file).putData(imageData!)
        } else {
            //Convert UIImage to Data
            let imageData = image.jpegData(compressionQuality: 1)
            //Save data to FirebaseStorage
            storage.child(path).child(file).putData(imageData!)
        }
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
