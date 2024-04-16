//
//  WorkoutsView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.

import SwiftUI

struct WorkoutsView: View {
    @State private var isActive: Bool = false
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var workoutViewModel: WorkoutViewModel
    @State private var showAlert = false

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
                        ForEach(workoutViewModel.workouts, id: \.id) { workout in
                            Workout(workout: workout)
                                .padding(.horizontal,10)
                        }
                       
                        
                        
//                        Workout()
//                            .padding(.horizontal,10)
//                        Workout()
//                            .padding(.horizontal,10)
//
                    }
                    Spacer()
                }
                
                .onAppear(){
                    
                    
                }
                .navigationTitle("Your Workouts 🏋️")
                
            }
        
            .overlay(
                Group {
                    if isActive {
                        AddWorkoutView(viewIsActive: $isActive, showAlert: $showAlert)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .edgesIgnoringSafeArea(.all)
                                            }
                    }
                    
                
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Workout Saved"), message: Text("Your workout has been successfully saved."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(){
            Task{
                try await workoutViewModel.fetchWorkoutsDescendingByDate()
            }
        }
        .onChange(of: isActive) {
            
                Task{
                    try await workoutViewModel.fetchWorkoutsDescendingByDate()
                }

        }
    }
}

#Preview {
    WorkoutsView()
        .environmentObject(ProfileViewModel())
        .environmentObject(WorkoutViewModel())
}
