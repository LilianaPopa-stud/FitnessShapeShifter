//
//  WorkoutManager.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 14.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct DBWorkout: Identifiable {
    @DocumentID var id: String?
    var name: String
    var exercises: [Exercise]
    
    struct Exercise: Identifiable {
        var id: String
        var name: String
        var sets: [Set]
        
        struct Set: Identifiable {
            var id: String
            var reps: Int
            var weight: Double
        }
    }
    
}
