//
//  AddWorkoutViewModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 12.04.2024.
//

import SwiftUI

@MainActor
class AddWorkoutViewModel: ObservableObject {
  @Published var workoutName = ""
// tuple which binds every exercise to its array of sets composed by reps and weight
    @Published var exercises: [Exercise] = []
    @Published var totalValueKg: Double = 0
    @Published var totalReps: Int = 0
    @Published var totalSets: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var date = Date()
    
    
    struct exercise: Identifiable {
        var id = UUID()
        var exercise: DBExercise
        var sets: [ExerciseSet]
    }

}


