//
//  UserModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 15.04.2024.
//

import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoURL: String?
    let dateCreated: Date
    let displayName: String?
    let gender: String?
    let age: Int?
    let weight: Double?
    let height: Double?
    let goal: String?
    let activityLevel: String?
    let measurementUnit: String?
    
    init(auth: AuthDataResultModel, displayName: String? = nil) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.displayName = displayName
        self.gender = nil
        self.age = nil
        self.weight = nil
        self.height = nil
        self.goal = nil
        self.activityLevel = nil
        self.measurementUnit = nil
    }
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
   
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case displayName = "display_name"
        case gender = "gender"
        case age = "age"
        case weight = "weight"
        case height = "height"
        case goal = "goal"
        case activityLevel = "activity_level"
        case measurementUnit = "measurement_unit"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        self.weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        self.height = try container.decodeIfPresent(Double.self, forKey: .height)
        self.goal = try container.decodeIfPresent(String.self, forKey: .goal)
        self.activityLevel = try container.decodeIfPresent(String.self, forKey: .activityLevel)
        self.measurementUnit = try container.decodeIfPresent(String.self, forKey: .measurementUnit)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.gender, forKey: .gender)
        try container.encodeIfPresent(self.age, forKey: .age)
        try container.encodeIfPresent(self.weight, forKey: .weight)
        try container.encodeIfPresent(self.height, forKey: .height)
        try container.encodeIfPresent(self.goal, forKey: .goal)
        try container.encodeIfPresent(self.activityLevel, forKey: .activityLevel)
        try container.encodeIfPresent(self.measurementUnit, forKey: .measurementUnit)
    }
}
