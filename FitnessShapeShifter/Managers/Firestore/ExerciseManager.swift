import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBExercise: Codable {
    let exerciseId: String
    let name: String
    let primaryMuscle: [String]
    let secondaryMuscle: [String]?
    let difficulty: String?
    let force: String?
    let mechanic: String?
    let equipment: String?
    var url: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exerciseId = try container.decode(String.self, forKey: .exerciseId)
        self.name = try container.decode(String.self, forKey: .name)
        self.primaryMuscle = try container.decode([String].self, forKey: .primaryMuscle)
        self.secondaryMuscle = try container.decodeIfPresent([String].self, forKey: .secondaryMuscle)
        self.difficulty = try container.decodeIfPresent(String.self, forKey: .difficulty)
        self.force = try container.decodeIfPresent(String.self, forKey: .force)
        self.mechanic = try container.decodeIfPresent(String.self, forKey: .mechanic)
        self.equipment = try container.decodeIfPresent(String.self, forKey: .equipment)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    enum CodingKeys: CodingKey {
        case exerciseId
        case name
        case primaryMuscle
        case secondaryMuscle
        case difficulty
        case force
        case mechanic
        case equipment
        case url
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.exerciseId, forKey: .exerciseId)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.primaryMuscle, forKey: .primaryMuscle)
        try container.encodeIfPresent(self.secondaryMuscle, forKey: .secondaryMuscle)
        try container.encodeIfPresent(self.difficulty, forKey: .difficulty)
        try container.encodeIfPresent(self.force, forKey: .force)
        try container.encodeIfPresent(self.mechanic, forKey: .mechanic)
        try container.encodeIfPresent(self.equipment, forKey: .equipment)
        try container.encodeIfPresent(self.url, forKey: .url)
    }
    
    init(exerciseId: String, name: String, primaryMuscle: [String], secondaryMuscle: [String]?, difficulty: String?, force: String?, mechanic: String?, equipment: String?, url: String?) {
        self.exerciseId = exerciseId
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscle = secondaryMuscle
        self.difficulty = difficulty
        self.force = force
        self.mechanic = mechanic
        self.equipment = equipment
        self.url = url
    }
}

final class ExerciseManager {
    static let shared = ExerciseManager()
    private init() {}
    
    private let db = Firestore.firestore()
    private let exerciseCollection = Firestore.firestore().collection("exercises")
    
   func fetchExercises() async throws -> [DBExercise] {
        let snapshot = try await exerciseCollection.getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: DBExercise.self)
        }
    }
    
    
    // get exercises
    
}


