//
//  UserManager.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    var userId: String
    var email: String?
    var photoURL: String?
    var dateCreated: Date
    var displayName: String?
    var gender: String?
    var age: Int?
    var weight: Double?
    var height: Double?
    var goal: String?
    var activityLevel: String?
    var measurementUnit: String?
    
    init(auth: AuthDataResultModel, displayName: String? = nil) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.displayName = displayName
    }
    
    // vezi care i faza, de ce nu-ti arata datele in profile view
    // si de ce la log in nu se incarca datele imediat, dar abia dupa ce intri in settings sau dupa ce dai log out si log in iar
    init(userId: String,
         email: String? = nil,
         photoURL: String? = nil,
         dateCreated: Date? = nil,
         displayName: String? = nil,
         age: Int? = nil,
         weight: Double? = nil,
         height: Double? = nil,
         activityLevel: String? = nil,
         goal: String? = nil,
         measurementUnit: String? = nil,
         gender: String? = nil) {
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated ?? Date()
        self.displayName = displayName
        self.age = age
        self.weight = weight
        self.height = height
        self.activityLevel = activityLevel
        self.goal = goal
        self.measurementUnit = measurementUnit
        self.gender = gender
    }
    
    
    
}

final class UserManager {
    //singleton
    static let shared = UserManager()
    private init () {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    
    //    func createNewUser(auth: AuthDataResultModel) async throws {
    //        var userData: [String: Any] = [
    //            "user_id": auth.uid,
    //            "date_created": Timestamp(),
    //            ]
    //        if let email = auth.email {
    //            userData["email"] = email
    //        }
    //        if let photoURL = auth.photoURL {
    //            userData["photo_url"] = photoURL
    //        }
    //
    //        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    //    }
    
    //    func fetchUser(userId: String) async throws -> DBUser {
    //        let snapshot = try await userDocument(userId: userId).getDocument()
    //
    //        guard let data = snapshot.data(), let userId = data["user_id"] as? String,  let email = data["email"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        let photoURL = data["photo_url"] as? String
    //        let dateCreated = data["date_created"] as? Date
    //        let displayName = data["display_name"] as? String
    //
    //        return DBUser(userId: userId, email: email, photoURL: photoURL, dateCreated: dateCreated ?? Date(), displayName: displayName)
    //    }
    
    func fetchUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func updateUser(userId: String, age: Int, weight: Double, height: Double, gender: String, goal: String, activityLevel: String, measurementUnit: String) async throws {
        let data: [String:Any] = [
            "age": age,
            "weight": weight,
            "height": height,
            "gender": gender,
            "goal": goal,
            "activity_level": activityLevel,
            "measurement_unit": measurementUnit
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
