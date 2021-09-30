//
//  FirestoreModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/27/21.
//

import SwiftUI
import FirebaseFirestore

extension FirebaseModel {        
    
    func save(collection: String, document: String, field: String, data: Any) {
        
        // Check if data is an array
        if let array = data as? [String] {
            //Append data in firestore
            db.collection(collection).document(document).updateData([field: FieldValue.arrayUnion(array)])
            
        // Check if data is a string
        } else if let string = data as? String {
            //Save data in firestore
            db.collection(collection).document(document).setValue(string, forKey: field)
        }
    }
    
    func getDoc(collection: String, id: String, completion:@escaping (DocumentSnapshot?) -> Void) {
        
        //Load Document
        db.collection(collection).document(id).getDocument { doc, error in
            
            //Check for error
            if error == nil {
                //Return Doc
                completion(doc)
            }
        }
    }
    
    func getDocs(collection: String, completion:@escaping (QuerySnapshot?) -> Void) {
        //Load Documents
        db.collection(collection).getDocuments { docs, error in
            
            //Check for error
            if error == nil {
                
                //Return documents
                completion(docs)
            }
        }
    }
    
    func newDoc(collection: String, document: String?, data: [String: Any], completion:@escaping (String?) -> Void) {
        
        //Check if should create random Id or input
        if document == nil {
            
            //Create then return docID
            let doc = db.collection(collection).addDocument(data: data)
            completion(doc.documentID)
        } else {
            
            //Create doc
            db.collection(collection).document(document!).setData(data)
        }
    }
}
