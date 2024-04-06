import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBExercise: Codable, Hashable, Identifiable {
    let exerciseId: String
    let name: String
    let primaryMuscle: [String]
    let secondaryMuscle: [String]?
    let difficulty: String?
    let force: String?
    let mechanic: String?
    let equipment: String?
    let url: String?
    let description: String?
    var id: String { exerciseId }
    
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
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
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
        case description
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
        try container.encodeIfPresent(self.description, forKey: .description)
    }
    
    init(exerciseId: String, name: String, primaryMuscle: [String], secondaryMuscle: [String]?, difficulty: String?, force: String?, mechanic: String?, equipment: String?, url: String?, description: String?) {
        self.exerciseId = exerciseId
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscle = secondaryMuscle
        self.difficulty = difficulty
        self.force = force
        self.mechanic = mechanic
        self.equipment = equipment
        self.url = url
        self.description = nil
    }
    init() {
        self.exerciseId = "okoaokw"
        self.name = "Lat Pulldown"
        self.primaryMuscle = ["Lats"]
        self.secondaryMuscle = ["Biceps"]
        self.difficulty = "Intermediate"
        self.force = "Pull"
        self.mechanic = "Compound"
        self.equipment = "Machine"
        self.url = ""
        self.description = "The lat pulldown is a compound exercise that strengthens the muscles in the back, shoulders, and arms. It specifically targets the latissimus dorsi, which is the large muscle that stretches from the middle of your back to your shoulder. This muscle is responsible for pulling movements, such as opening a door or pulling yourself up."
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
    
    func updateExercise(exercise: DBExercise) throws {
        try exerciseCollection.document(exercise.exerciseId).setData(from: exercise)
    }
    
    func setDescription(exerciseName: String, description: String) async throws {
        let querySnapshot = try await exerciseCollection.whereField("name", isEqualTo: exerciseName).getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            return // Handle error if document is not found
        }
        
        try await document.reference.updateData(["description": description])
    }
    // get exercises
    
}


