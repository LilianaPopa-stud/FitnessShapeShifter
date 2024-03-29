//
//  WorkoutsView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject var viewModel = ExerciseViewModel()
    var body: some View {
        ZStack{
            AppBackground()
            NavigationView {
                VStack {
                    // button "Add workout"
                 
                    //list of workouts
                    ScrollView {
                        AddWorkoutButton()
                            .padding(30)
                        Workout()
                            .padding(.horizontal,10)
                        Workout()
                            .padding(.horizontal,10)
                        Workout()
                            .padding(.horizontal,10)
                        
                        ForEach(viewModel.exercises, id: \.exerciseId) { exercise in
                            Text(exercise.name)
                                .padding(.horizontal, 10)
                        }}
                    Spacer()
                }
                .onAppear(){
                    Task {
                        await viewModel.fetchExercises()
                    }
                }
                .navigationTitle("Your Workouts 🏋️")
                
            }
        }
    }
}

#Preview {
    WorkoutsView()
}
