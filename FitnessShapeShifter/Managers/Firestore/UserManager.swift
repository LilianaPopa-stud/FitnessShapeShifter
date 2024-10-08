//
//  UserManager.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class UserManager {
    
    static let shared = UserManager()
    private init () {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func fetchUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUser(userId: String, age: Int, weight: Double, height: Double, gender: String, goal: String, activityLevel: String, measurementUnit: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.age.rawValue: age,
            DBUser.CodingKeys.weight.rawValue: weight,
            DBUser.CodingKeys.height.rawValue: height,
            DBUser.CodingKeys.gender.rawValue: gender,
            DBUser.CodingKeys.goal.rawValue: goal,
            DBUser.CodingKeys.activityLevel.rawValue: activityLevel,
            DBUser.CodingKeys.measurementUnit.rawValue: measurementUnit
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfile(userId: String, displayName: String, age: Int, weight: Double, height: Double) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.displayName.rawValue: displayName,
            DBUser.CodingKeys.age.rawValue: age,
            DBUser.CodingKeys.weight.rawValue: weight,
            DBUser.CodingKeys.height.rawValue: height
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImage(userId: String, photoURL: String) async throws{
        let data: [String:String] = [
            DBUser.CodingKeys.photoURL.rawValue: photoURL
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    // collection for workouts
    
    private func workoutCollection (userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("workouts")
    }
    private func workoutDocument(userId: String,workoutId: String) -> DocumentReference {
        workoutCollection(userId: userId).document(workoutId)
    }
    
    func deleteWorkout(userId: String, workoutId: String) async throws {
        try await workoutCollection(userId: userId).document(workoutId).delete()
    }
    
    func addWorkout(workout: DBWorkout, userId: String, exercises: [ExerciseInWorkout]) async throws {
        let document = workoutCollection(userId: userId).document()
        
        var workoutData = try Firestore.Encoder().encode(workout)
        workoutData["id"] = document.documentID
        workoutData["nrOfExercises"] = exercises.count
        try await document.setData(workoutData)
        
        for exercise in exercises {
            let exerciseDocument = document.collection("exercises").document()
            var exerciseData = try Firestore.Encoder().encode(exercise)
            exerciseData["id"] = exerciseDocument.documentID
            try await exerciseDocument.setData(exerciseData)
        }
    }
    
    func fetchWorkouts(userId: String) async throws -> [DBWorkout] {
        var workouts: [DBWorkout] = []
        let querySnapshot = try await workoutCollection(userId: userId).getDocuments()
        
        for document in querySnapshot.documents {
            let workoutData = document.data()
            var workout = try Firestore.Decoder().decode(DBWorkout.self, from: workoutData)
            
            let exerciseDocuments = try await document.reference.collection("exercises").getDocuments()
            var exercises: [ExerciseInWorkout] = []
            for exerciseDocument in exerciseDocuments.documents {
                let exerciseData = exerciseDocument.data()
                guard let exerciseId = exerciseData["exerciseId"] as? String,
                      let setsData = exerciseData["sets"] as? [[String: Any]] else {
                    break;
                }
                let sets = setsData.compactMap { setData -> ExerciseSet? in
                    guard let reps = setData["reps"] as? Int,
                          let weight = setData["weight"] as? Double else {
                        
                        return nil
                    }
                    return ExerciseSet(reps: reps, weight: weight)
                }
                let exercise = ExerciseInWorkout(id: exerciseDocument.documentID, exerciseId: exerciseId, sets: sets)
                exercises.append(exercise)
            }
            workout.setExercises(exercises: exercises)
            
            workouts.append(workout)
        }
        
        return workouts
    }
    
    func fetchWorkoutsDescendingByDate(userId: String) async throws -> [DBWorkout] {
        var workouts: [DBWorkout] = []
        
        let querySnapshot = try await workoutCollection(userId: userId).order(by: "date", descending: true).getDocuments()
        
        for document in querySnapshot.documents {
            let workoutData = document.data()
            var workout = try Firestore.Decoder().decode(DBWorkout.self, from: workoutData)
            
            let exerciseDocuments = try await document.reference.collection("exercises").getDocuments()
            var exercises: [ExerciseInWorkout] = []
            for exerciseDocument in exerciseDocuments.documents {
                let exerciseData = exerciseDocument.data()
                guard let exerciseId = exerciseData["exerciseId"] as? String,
                      let setsData = exerciseData["sets"] as? [[String: Any]] else {
                    break;
                }
                let sets = setsData.compactMap { setData -> ExerciseSet? in
                    guard let reps = setData["reps"] as? Int,
                          let weight = setData["weight"] as? Double else {
                        return nil
                    }
                    return ExerciseSet(reps: reps, weight: weight)
                }
                let exercise = ExerciseInWorkout(id: exerciseDocument.documentID, exerciseId: exerciseId, sets: sets)
                exercises.append(exercise)
            }
            workout.setExercises(exercises: exercises)
            workouts.append(workout)
        }
        
        return workouts
    }
    
    
    
    func updateWorkout(userId: String, workoutId: String, exercises: [ExerciseInWorkout], totalReps: Int, totalSets: Int, totalValueKg: Double, totalCalories: Int) async throws {
        let workoutDocument = workoutCollection(userId: userId).document(workoutId)
        let exerciseDocuments = try await workoutDocument.collection("exercises").getDocuments()
        for document in exerciseDocuments.documents {
            try await document.reference.delete()
        }
        
        let data: [String:Any] = [
            "totalReps": totalReps,
            "totalSets": totalSets,
            "totalWeight": totalValueKg,
            "totalCalories": totalCalories,
            "nrOfExercises": exercises.count
        ]
        try await workoutDocument.updateData(data)
        for exercise in exercises {
            let exerciseDocument = workoutDocument.collection("exercises").document(exercise.id)
            let exerciseData = try Firestore.Encoder().encode(exercise)
            try await exerciseDocument.setData(exerciseData)
        }
    }
    
    func updateWorkoutDetails(userId: String, workoutId: String, workoutTitle: String, workoutDate: Date) async throws {
        let data: [String:Any] = [
            "title": workoutTitle,
            "date": workoutDate
        ]
        try await workoutDocument(userId: userId, workoutId: workoutId).updateData(data)
    }
    
    func fetchWorkoutsInDateRange(userId: String, startDate: Date, endDate: Date) async throws  -> [DBWorkout] {
        var workouts: [DBWorkout] = []
        let query = try await workoutCollection(userId: userId).whereField("date", isGreaterThanOrEqualTo: startDate).whereField("date", isLessThanOrEqualTo: endDate).getDocuments()
        
        for document in query.documents {
            let workoutData = document.data()
            var workout = try Firestore.Decoder().decode(DBWorkout.self, from: workoutData)
            workouts.append(workout)
        }
        print(workouts)
        return workouts
        
    }
    
    
    
    
}


