//
//  AddWorkoutViewModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 12.04.2024.
//

import SwiftUI

@MainActor
class WorkoutViewModel: ObservableObject {
    @Published var workoutName = ""
    @Published var totalValueKg: Double = 0
    @Published var totalReps: Int = 0
    @Published var totalSets: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var caloriesBurned: Int = 0
    @Published var date = Date()
    @Published var tuples : [Exercise] = []
    @Published var workouts: [DBWorkout] = []
    
    var isLoading: Bool = true
    private let userManager = UserManager.shared
    private let exerciseManager = ExerciseManager.shared
    @State var exercisesViewModel = ExerciseViewModel()
    
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
            self.workouts = workouts
        } catch {
            print("Error fetching workouts:", error)
        }
        
    }
    
    func fetchWorkoutsDescendingByDate() async throws {
        print(isLoading)
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            let workouts = try await userManager.fetchWorkoutsDescendingByDate(userId: authData.uid)
            self.workouts = workouts
        } catch {
            print("Error fetching workouts:", error)
        }
        isLoading = false
        print(isLoading)
        
    }
    
    
    func getWorkoutExercises(workout: DBWorkout) async throws -> [(ExerciseInWorkout,DBExercise)] {
        var exercises:[(ExerciseInWorkout,DBExercise)] = []
        do {
            for exercise in workout.exercises {
                let exerciseData = try await exercisesViewModel.getExercise(id: exercise.exerciseId)
                exercises.append((exercise,exerciseData))
            }
            
        } catch {
            print("Error fetching exercises:", error) // catch error and handle it
        }
        return exercises
    }
    
    func deleteWorkout(workoutId: String) async {
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            try await userManager.deleteWorkout(userId: authData.uid, workoutId: workoutId)
            print ("Workout deleted")
            print(workoutId)
            print(authData.uid)
        } catch {
            print("Error deleting workout:", error)
        }
    }

    
    // save workout to firestore
    // trebuie sa adaug si datele de la user
    
    
    
    
    
    
}


