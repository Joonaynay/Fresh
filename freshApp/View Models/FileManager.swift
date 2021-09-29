//
//  FileManager.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/28/21.
//

import SwiftUI

struct FileManagerModel{
    
    func saveImage(image: UIImage, name: String) {
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(name).jpg") else { return }
        do {
            try imageData?.write(to: path)
            
        } catch let error {
            print("Error writing to data. \(error)")
        }
        
        
    }
    
    func getPath(name: String) -> URL? {
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(name).jpg") else { return nil }
        
        return path

        
    }
    
    
    func getFromFileManager(name: String) -> UIImage? {
        
        guard let path = getPath(name: name)?.path else { return nil}
        
        return UIImage(contentsOfFile: path)
    }
    
}
