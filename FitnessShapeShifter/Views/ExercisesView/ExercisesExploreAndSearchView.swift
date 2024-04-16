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
                    ScrollView (showsIndicators: false) {
                        VStack {
                            if searchText.isEmpty {
                                //                                Text("Some inspiration for your workouts 🏋️‍♀️")
                                //                                    .font(Font.custom("Bodoni 72", size: 30, relativeTo: .title))
                                //                                   // .font(.title)
                                //                                    .padding(.horizontal,10)
                                //                                    .padding(.top,10)
                                //                                    .multilineTextAlignment(.center)
                                ForEach(splitPPL, id: \.self) { splitPPL in
                                    VStack(alignment: .leading) {
                                        Text(splitPPL)
                                            .font(.title2)
                                            .bold()
                                            .padding(.horizontal)
                                            .padding(.top,10)
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack {
                                                ForEach(getRandomExercisesPPL(for: splitPPL), id: \.exerciseId) { exercise in
                                                    NavigationLink(destination: ExerciseView(exercise: exercise)) {
                                                        ExerciseView(exercise: exercise)
                                                            .scaleEffect(1)
                                                            .frame(maxWidth: 330)
                                                            .padding(.vertical,10)
                                                            .padding(.leading,10)
                                                    }
                                                    .foregroundColor(.black)
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            else {
                                if filteredExercises.isEmpty {
                                    Text("No exercises found.")
                                        .foregroundColor(.gray) // You can adjust color as per your UI
                                        .padding()
                                }
                                else {
                                    ForEach(filteredExercises, id: \.exerciseId) { exercise in
                                        NavigationLink(destination: ExerciseView(exercise: exercise)) {
                                            ExerciseView(exercise: exercise)
                                                .padding(.vertical,10)
                                                .scaleEffect(0.95)
                                                .frame(maxWidth: 330)
                                        }
                                        .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(.bottom,10)
                        .padding(.leading,5)
                        
                    }
                }
                .navigationTitle("Library")
                .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Search exercises")
            }
        }
        .onAppear {
            Task{
                await viewModel.fetchExercises()
            }
        }
    }
    
    private func getRandomExercisesPPL(for splitPPL: String) -> [DBExercise]{
        let filteredExercises: [DBExercise]
         
        switch splitPPL {
        case "Pull":
            filteredExercises = viewModel.exercises.filter { $0.primaryMuscle.contains("Biceps") || $0.primaryMuscle.contains("Lats") }
        case "Push":
            filteredExercises = viewModel.exercises.filter { $0.primaryMuscle.contains("Chest") || $0.primaryMuscle.contains("Shoulders") || $0.primaryMuscle.contains("Triceps") }
        case "Legs":
            filteredExercises = viewModel.exercises.filter { $0.primaryMuscle.contains("Quadriceps") || $0.primaryMuscle.contains("Hamstrings") || $0.primaryMuscle.contains("Glutes") || $0.primaryMuscle.contains("Calves")}
        case "Core":
            filteredExercises = viewModel.exercises.filter { $0.primaryMuscle.contains("Abdominals") || $0.primaryMuscle.contains("Obliques") }
        default:
            filteredExercises = []
        }
        
        let shuffledExercises = filteredExercises.shuffled()
        return Array(shuffledExercises.prefix(Int.random(in: 3...5)))
    }
    
    private var filteredExercises: [DBExercise] {
        if searchText.isEmpty {
            return viewModel.exercises
        } else {
            return viewModel.exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    let splitPPL: [String] = [
        "Pull", "Push", "Legs", "Core"
    ]
}

#Preview {
    ExercisesExploreAndSearchView()
}
