//
//  WorkoutsView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.

import SwiftUI

struct WorkoutsView: View {
    @State private var isActive: Bool = false
    @StateObject var viewModel = ExerciseViewModel()
    @EnvironmentObject var profileViewModel: ProfileViewModel

    var body: some View {
        ZStack{
            AppBackground()
            NavigationView {
                VStack {
                    // button "Add workout"
                    //list of workouts
                    ScrollView {
                        AddWorkoutButton(isActive: $isActive)
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
                        // print name of each exercise
                        for exercise in viewModel.exercises {
                            print(exercise.name)
                        }
                    }
                }
                .navigationTitle("Your Workouts 🏋️")
                
            }
            .overlay(
                Group {
                    if isActive {
                        AddWorkoutView(viewIsActive: $isActive)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            )
        }
    }
}

#Preview {
    WorkoutsView()
        .environmentObject(ProfileViewModel())
}
