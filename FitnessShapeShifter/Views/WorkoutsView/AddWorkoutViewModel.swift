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
    @Published var date = Date()
    @Published var tuples : [Exercise] = []
    
    // save workout to firestore
    // trebuie sa adaug si datele de la user
    
   
    
    
    
    
}


