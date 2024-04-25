//
//  StatsViewModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 25.04.2024.
//

import Foundation

@MainActor
class StatsViewModel: ObservableObject {
    
    @Published var nrOfWorkouts: Int = 0
    @Published var TVL: Int = 0
    @Published var calories: Int = 0
    @Published var reps: Int = 0
    @Published var sets: Int = 0
    @Published var hours: Double = 0.0
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedDateRange: DateInterval = DateInterval()
    
    private let userManager = UserManager.shared
    
    // all time stats
    func fetchStats() async throws {
       // get user id
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid

        // get user workouts
        let workouts = try await userManager.fetchWorkouts(userId: userId)
        nrOfWorkouts = workouts.count
        TVL = workouts.map{Int($0.totalWeight)}.reduce(0,+)
        calories = workouts.map{$0.totalCalories}.reduce(0,+)
        reps = workouts.map{$0.totalReps}.reduce(0,+)
        sets = workouts.map{$0.totalSets}.reduce(0,+)
        hours = workouts.map{Double($0.duration)}.reduce(0,+)
        
        // get user exercises
    
        
        
    }
    
}
