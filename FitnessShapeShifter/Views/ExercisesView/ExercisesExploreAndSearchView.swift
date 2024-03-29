//
//  ExercisesExploreAndSearchView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 29.03.2024.
//

import SwiftUI

struct ExercisesExploreAndSearchView: View {
    @StateObject var viewModel = ExerciseViewModel()
    @State private var searchText = ""
    @State private var searchIsActive = false
    var body: some View {
        ZStack{
            AppBackground()
            NavigationView {
                VStack {
                   
                                  
                    
                    
                }
                .navigationTitle("Library")
                .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Search exercises")
            }
        }
    }
    private func getRandomExercises(for muscleGroup: String) -> [DBExercise] {
           let filteredExercises = viewModel.exercises.filter { $0.primaryMuscle.contains(muscleGroup) }
           let shuffledExercises = filteredExercises.shuffled()
           return Array(shuffledExercises.prefix(Int.random(in: 3...5))) // Adjust the range as needed
       }
}

#Preview {
    ExercisesExploreAndSearchView()
}
