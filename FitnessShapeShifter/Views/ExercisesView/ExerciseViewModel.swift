//
//  ExerciseViewModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 29.03.2024.
//

import Foundation
import SwiftUI

@MainActor
final class ExerciseViewModel: ObservableObject {
    @Published var exercises: [DBExercise] = []
    @Published var isLoading = false
    @Published var error: NSError? = nil
    @Published var muscleGroups: [String] = [
        "Biceps", "Triceps",
        "Chest", "Inner Chest", "Lower Chest", "Upper Chest",
        "Lats",
        "Abdominals",
        "Quadriceps",
        "Hamstrings",
        "Shoulders", "Front Shoulders",
        "Traps",
        "Calves",
        "Glutes",
        "Lower Back",
        "Forearms",
        "Obliques",
        "Adductors"
    ]
    @Published var equipmentTypes: [String] = [
        "Barbell", "Dumbbell", "Cable Machine", "Machine", "Bodyweight", "Kettlebell", "Ez-Bar", "Preacher Bench", "Pull-up Bar", "T-Bar"
    ]
    
    
    func fetchExercises() async {
        isLoading = true
        do {
            let exercises = try await ExerciseManager.shared.fetchExercises()
            self.exercises = exercises
        } catch {
            self.error = error as NSError
        }
        isLoading = false
    }
    
}
