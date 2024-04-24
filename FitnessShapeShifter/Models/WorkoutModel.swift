//
//  WorkoutModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 15.04.2024.
//

import Foundation
struct DBWorkout: Codable, Identifiable {
    var id: String
    var date: Date
    var title: String
    var duration: TimeInterval
    var totalReps: Int
    var totalSets: Int
    var totalWeight: Double
    var totalCalories: Int
    
    var exercises: [ExerciseInWorkout]
    
    
    // setter for exercises
    mutating func setExercises(exercises: [ExerciseInWorkout]) {
        self.exercises = exercises
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.totalReps, forKey: .totalReps)
        try container.encode(self.totalSets, forKey: .totalSets)
        try container.encode(self.totalWeight, forKey: .totalWeight)
        try container.encode(self.totalCalories, forKey: .totalCalories)
        
    }
    enum CodingKeys: CodingKey {
        case id
        case date
        case title
        case duration
        case totalReps
        case totalSets
        case totalWeight
        case totalCalories
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.title = try container.decode(String.self, forKey: .title)
        self.duration = try container.decode(TimeInterval.self, forKey: .duration)
        self.totalReps = try container.decode(Int.self, forKey: .totalReps)
        self.totalSets = try container.decode(Int.self, forKey: .totalSets)
        self.totalWeight = try container.decode(Double.self, forKey: .totalWeight)
        self.totalCalories = try container.decode(Int.self, forKey: .totalCalories)
        self.exercises = []
    }
    
    init(id: String, date: Date, title: String, duration: TimeInterval, totalReps: Int, totalSets: Int, totalWeight: Double,totalCalories: Int, exercises: [ExerciseInWorkout]) {
        self.id = id
        self.date = date
        self.title = title
        self.duration = duration
        self.totalReps = totalReps
        self.totalSets = totalSets
        self.totalWeight = totalWeight
        self.totalCalories = totalCalories
        self.exercises = exercises
    }
    init(date: Date, title: String, duration: TimeInterval, totalReps: Int, totalSets: Int, totalWeight: Double, totalCalories: Int, exercises: [ExerciseInWorkout]) {
        self.id = UUID().uuidString
        self.date = date
        self.title = title
        self.duration = duration
        self.totalReps = totalReps
        self.totalSets = totalSets
        self.totalWeight = totalWeight
        self.totalCalories = totalCalories
        self.exercises = exercises
    }
    init(){
        self.id = UUID().uuidString
        self.date = Date()
        self.title = "My Workout"
        self.duration = 10000
        self.totalReps = 192
        self.totalSets = 28
        self.totalWeight = 9088
        self.totalCalories = 200
        self.exercises = [ExerciseInWorkout(exerciseId: "0608158C-6B28-4568-A69C-810DE6A1915B", sets: [ExerciseSet(reps: 10, weight: 10),ExerciseSet(reps: 10, weight: 15)]),ExerciseInWorkout(exerciseId: "32C22586-49B6-48CB-AD85-7BC603BF27CF"
, sets: [ExerciseSet(reps: 10, weight: 19)])]
    }
    
}

struct ExerciseInWorkout: Codable, Hashable {
    
    var id: String // that's the document id, because you can have the same exercise multiple times in a workout
    var exerciseId: String 
    var sets: [ExerciseSet]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.exerciseId, forKey: .exerciseId)
        try container.encode(self.sets, forKey: .sets)
    }
    enum CodingKeys: CodingKey {
        case id
        case exerciseId
        case sets
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.exerciseId = try container.decode(String.self, forKey: .exerciseId)
        self.sets = try container.decode([ExerciseSet].self, forKey: .sets)
    }
    
    init(exerciseId: String, sets: [ExerciseSet]){
        self.id = UUID().uuidString
        self.exerciseId = exerciseId
        self.sets = sets
    }
    
    init (id: String, exerciseId: String, sets: [ExerciseSet]){
        self.id = id
        self.exerciseId = exerciseId
        self.sets = sets
    }
   // only for testing, delete later
    
    init(){
        self.id = UUID().uuidString
        self.exerciseId = "00FAA790-3BE9-4A11-A1FE-9FCCD1D3A36C"
        self.sets = [ExerciseSet(reps: 10, weight: 10),ExerciseSet(reps: 10, weight: 15)]
    }
    
   
  
}

struct ExerciseSet: Codable,Hashable {

    var reps: Int
    var weight: Double
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.reps, forKey: .reps)
        try container.encode(self.weight, forKey: .weight)
    }
    enum CodingKeys: CodingKey {
        case reps
        case weight
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reps = try container.decode(Int.self, forKey: .reps)
        self.weight = try container.decode(Double.self, forKey: .weight)
    }
    init(reps: Int, weight: Double){
        self.reps = reps
        self.weight = weight
    }
    
}
