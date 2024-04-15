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
    @Published var totalValueKg: Double = 0
    @Published var totalReps: Int = 0
    @Published var totalSets: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var caloriesBurned: Int = 0
    @Published var date = Date()
    @Published var tuples : [Exercise] = []
    
    
    private let userManager = UserManager.shared
    
    func addWorkout() async {
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            var exercises: [ExerciseInWorkout] = []
            for tuple in tuples { // exercise - sets
                let exercise = ExerciseInWorkout(exerciseId: tuple.exercise.id, sets: tuple.sets)
                exercises.append(exercise)
            }
            let workout = DBWorkout(date: date, title: workoutName, duration: elapsedTime, totalReps: totalReps, totalSets: totalSets, totalWeight: totalValueKg, totalCalories: Int(caloriesBurned),exercises: exercises)
            try await userManager.addWorkout(workout: workout, userId: authData.uid, exercises: exercises)
        } catch {
            print("Error adding workout:", error)
        }
    }
    
   
    func fetchWorkouts() async throws{
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            let workouts = try await userManager.fetchWorkouts(userId: authData.uid)
            print(workouts)
        } catch {
            print("Error fetching workouts:", error)
        }
    }
    
    // save workout to firestore
    // trebuie sa adaug si datele de la user
    
    
    
    
    
    
}


