//
//  ExerciseViewModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 29.03.2024.
//

import Foundation
import SwiftUI

final class ExerciseViewModel: ObservableObject {
    @Published var exercises: [DBExercise] = []
    @Published var isLoading = false
    @Published var error: NSError? = nil
    
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
