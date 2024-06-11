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
    
    func imageName(for muscle: String) -> String {
        switch muscle {
        case "Biceps":
            return "Biceps"
        case "Triceps":
            return "Triceps"
        case "Chest", "Inner Chest", "Lower Chest", "Upper Chest":
            return "Chest"
        case "Lats":
            return "Lats"
        case "Abdominals":
            return "Abdominals"
        case "Quadriceps":
            return "Quads"
        case "Hamstrings":
            return "Hamstrings"
        case "Shoulders":
            return "Deltoid"
        case "Front Shoulders":
            return "Deltoid"
        case "Traps":
            return "Traps"
        case "Calves":
            return "Calves"
        case "Glutes":
            return "Glutes"
        case "Lower Back":
            return "Lowerback"
        case "Forearms":
            return "Forearm"
        case "Obliques":
            return "Obliques"
        case "Adductors":
            return "Adductor"
        default:
            return "none"
        }
    }
    
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
    
    func updateWorkout(workout: DBWorkout) async {
        if workoutName.isEmpty {
            workoutName = workout.title
        }
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            var exercises: [ExerciseInWorkout] = []
            for tuple in tuples { // exercise - sets
                let exercise = ExerciseInWorkout(exerciseId: tuple.exercise.id, sets: tuple.sets)
                exercises.append(exercise)
            }
           
            try await userManager.updateWorkout(userId: authData.uid, workoutId: workout.id, exercises: exercises, totalReps: totalReps, totalSets: totalSets, totalValueKg: totalValueKg, totalCalories: Int(caloriesBurned))
        } catch {
            print("Error updating workout:", error)
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
  
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            let workouts = try await userManager.fetchWorkoutsDescendingByDate(userId: authData.uid)
            self.workouts = workouts
        } catch {
            print("Error fetching workouts:", error)
        }
        isLoading = false
        
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
        } catch {
            print("Error deleting workout:", error)
        }
    }
    
    func updateWorkoutDetails(workoutId: String, workoutTitle: String, workoutDate: Date) async {
       
        do {
            let authData = try AuthenticationManager.shared.getAuthenticatedUser()
            try await userManager.updateWorkoutDetails(userId: authData.uid, workoutId: workoutId, workoutTitle: workoutTitle, workoutDate: workoutDate)
        } catch {
            print("Error updating workout:", error)
        }
    }
    
   
    
}




