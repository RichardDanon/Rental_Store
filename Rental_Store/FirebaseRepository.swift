//
//  FirebaseRepository.swift
//  Rental_Store
//
//  Created by Richard on 2023-12-11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseRepository: ObservableObject {
    private let store = Firestore.firestore()

    // Fetch all documents in a collection
    func fetchCollection<T: Codable>(collectionPath: String, completion: @escaping ([T]) -> Void) {
        store.collection(collectionPath).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let data = documents.compactMap { document -> T? in
                return try? document.data(as: T.self)
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }

    // Add a document to a collection
    func addDocument<T: Codable>(to collectionPath: String, document: T) {
        do {
            _ = try store.collection(collectionPath).addDocument(from: document)
        } catch {
            fatalError("Adding document failed: \(error)")
        }
    }

    // Update a document in a collection
    func updateDocument<T: Codable>(in collectionPath: String, documentID: String, document: T) {
        do {
            _ = try store.collection(collectionPath).document(documentID).setData(from: document)
        } catch {
            fatalError("Updating document failed: \(error)")
        }
    }
    
//    func updateDocumentFields(in collectionPath: String, documentID: String, fields: [String: Any]) {
//        let documentRef = store.collection(collectionPath).document(documentID)
//        documentRef.updateData(fields) { error in
//            if let error = error {
//                print("Error updating document fields: \(error)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//    }

    func updateDocumentFields(in collectionPath: String, documentID: String, fields: [String: Any]) {
        let documentRef = store.collection(collectionPath).document(documentID)
        documentRef.updateData(fields) { error in
            if let error = error {
                print("Error updating document fields: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
    }


    // Add data to a subcollection within a document
    func addToSubcollection<T: Codable>(in collectionPath: String, documentID: String, subcollection: String, data: T) {
        let subcollectionRef = store.collection(collectionPath).document(documentID).collection(subcollection)
        do {
            _ = try subcollectionRef.addDocument(from: data)
        } catch {
            print("Adding data to subcollection failed: \(error)")
        }
    }

    // Delete a document from a collection
    func deleteDocument(from collectionPath: String, documentID: String) {
        store.collection(collectionPath).document(documentID).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            }
        }
    }

    // Delete a collection and its contents
    func deleteCollection(collectionPath: String, batchSize: Int = 100) {
        let collectionRef = store.collection(collectionPath)
        deleteCollectionStep(collectionRef: collectionRef, batchSize: batchSize)
    }

    private func deleteCollectionStep(collectionRef: CollectionReference, batchSize: Int) {
        collectionRef.limit(to: batchSize).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching documents to delete: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            guard !snapshot.isEmpty else { return }

            let batch = self.store.batch()
            snapshot.documents.forEach { batch.deleteDocument($0.reference) }

            batch.commit { error in
                if let error = error {
                    print("Delete batch failed: \(error)")
                } else if snapshot.count >= batchSize {
                    self.deleteCollectionStep(collectionRef: collectionRef, batchSize: batchSize)
                }
            }
        }
    }
}

