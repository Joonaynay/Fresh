//
//  FirestoreModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/27/21.
//

import SwiftUI
import FirebaseFirestore

extension FirebaseModel {
    
    func saveDeep(collection: String, collection2: String, document: String, document2: String, field: String, data: Any) {
        
        let document = db.collection(collection).document(document).collection(collection2).document(document2)
        
        document.getDocument { doc, error in
            if doc != nil && error == nil {
                // Check if data is an array
                if let array = data as? [String] {
                    //Append data in firestore
                    if doc?.get("comments") != nil {
                        print("ooga booga")
                        document.updateData([field: FieldValue.arrayUnion(array)])
                    } else {
                        document.setData([field: data])
                    }
                    
                    
                // Check if data is a string
                } else if let string = data as? String {
                    //Save data in firestore
                    document.setValue(string, forKey: field)
                }
            }
        }
    }
    
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
        if !id.isEmpty {
            //Load Document
            db.collection(collection).document(id).getDocument { doc, error in
                if error == nil {
                    completion(doc)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func getDocs(collection: String, completion:@escaping (QuerySnapshot?) -> Void) {
        
        
        //Load Documents
        db.collection(collection).getDocuments { docs, error in
            
            //Check for error
            if error == nil {
                //Return documents
                completion(docs)
            } else {
                completion(nil)
            }
        }
    }
    
    func getDocsDeep(collection: String, document: String, collection2: String, completion:@escaping (QuerySnapshot?) -> Void) {
        //Load Documents
        db.collection(collection).document(document).collection(collection2).getDocuments { docs, error in
            
            //Check for error
            if error == nil {
                
                //Return documents
                completion(docs)
            } else {
                completion(nil)
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
