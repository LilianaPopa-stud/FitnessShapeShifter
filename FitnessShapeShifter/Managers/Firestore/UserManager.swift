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
    
    func addWorkout(workout: DBWorkout, userId: String, exercises: [ExerciseInWorkout]) async throws {
        let document = workoutCollection(userId: userId).document()
        
        let workoutData = try Firestore.Encoder().encode(workout)
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
        print ("querySnapshot: \(querySnapshot.documents.count)")
        
        // Iterate through each workout document
        for document in querySnapshot.documents {
            let workoutData = document.data()
            var workout = try Firestore.Decoder().decode(DBWorkout.self, from: workoutData)
            
            // Fetch exercises for the workout
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
                        // Handle missing or invalid set data
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
                        // Handle missing or invalid set data
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

    

    
}


