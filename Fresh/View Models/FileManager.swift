//
//  FileManager.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/28/21.
//

import SwiftUI

struct FileManagerModel {
    
    func saveImage(image: UIImage, name: String) {
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(name).jpeg") else { return }
        do {
            try imageData?.write(to: path)
            
        } catch let error {
            print("Error writing to data. \(error)")
        }
        
        
    }
    
    func getPath(name: String) -> URL? {
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(name).jpeg") else { return nil }
        
        return path

        
    }
    
    
    func getFromFileManager(name: String) -> UIImage? {
        
        guard let path = getPath(name: name)?.path else { return nil }
        
        return UIImage(contentsOfFile: path)
    }
    
    func deleteAllImages() {
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let urls = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for url in urls {
                if url.pathExtension == "jpeg" || url.pathExtension == "mp3" {
                    try FileManager.default.removeItem(at: url)
                }
            }
        } catch  { print(error) }
    }
    
//    func getMovie(url: URL) -> Data {
//        do {
//            let movie = try Data(contentsOf: url)
//            return movie
//        } catch let error {
//            fatalError(error.localizedDescription)
//        }
//    }
    
}
