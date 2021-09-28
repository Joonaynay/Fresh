//
//  FirestoreModel.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/27/21.
//

import SwiftUI
import FirebaseFirestore

struct FirestoreModel {
    
    @EnvironmentObject var fb: FirebaseModel
    let db = Firestore.firestore()
    
    func save(collection: String, document: String, field: String, data: Any) {
        if let array = data as? [String] {
            db.collection(collection).document(document).updateData([field: FieldValue.arrayUnion(array)])
        } else if let string = data as? String {
            db.collection(collection).document(document).setValue(string, forKey: field)
        }
    }
    
    func getDoc(collection: String, id: String, completion:@escaping (DocumentSnapshot?) -> Void) {
        db.collection(collection).document(id).getDocument { doc, error in
            if error == nil {
                completion(doc)
            }
        }
    }
    
    func getDocs(collection: String, completion:@escaping (QuerySnapshot?) -> Void) {
        db.collection(collection).getDocuments { docs, error in
            if error == nil {
                completion(docs)
            }
        }
    }
    
    func newDoc(collection: String, document: String?, data: [String: Any], completion:@escaping (String?) -> Void) {
        if document == nil {
            let doc = db.collection(collection).addDocument(data: data)
            completion(doc.documentID)
        } else {
            db.collection(collection).document(document!).setData(data)
        }
    }
}
