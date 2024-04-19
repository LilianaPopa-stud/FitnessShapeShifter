
//  WorkoutsView.swift
//  FitnessShapeShifter
//  Created by Liliana Popa on 27.03.2024.

import SwiftUI

struct Workouts: View {
    @State private var isActive: Bool = false
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var workoutViewModel: WorkoutViewModel
    @State private var showAlert = false
    @State private var refreshWorkouts = false
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = false
    @State var detailsViewIsActive = false

    var body: some View {
        ZStack {
            AppBackground()
            NavigationView {
                VStack {
                    // button "Add workout"
                    //list of workouts
                    ScrollView {
                        AddWorkoutButton(isActive: $isActive)
                            .padding(30)
                        HStack {
                            Button(action: {
                                isDatePickerVisible.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                        .foregroundColor(.accentColor2)
                                }
                            }
                            if isDatePickerVisible {
                                Group {
                                    DatePicker("Filter by date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                                        .padding(.horizontal)
                                      }
                                  
                                  .colorInvert()
                                      .colorMultiply(Color.accentColor2)
                            } else {
                                Text(selectedDate, style: .date)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                        if workoutViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5, anchor: .center)
                                .padding(40)
                                .foregroundStyle(.gray)
                        }
                        else if workoutViewModel.workouts.isEmpty && !workoutViewModel.isLoading {
                            Text("You have no workouts logged yet.")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.top, 20)
                                .foregroundStyle(.gray)
                        }
                        else {
                            if filteredWorkouts.isEmpty {
                                Text("No workouts logged on this date.")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.top, 80)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 20)
                            }
                            ForEach(filteredWorkouts, id: \.id){ workout in
                                NavigationLink(
                                    destination:
                                        WorkoutDetails(isActive: $detailsViewIsActive, workout: workout/*workout: workout, refreshWorkouts: $refreshWorkouts*/)
                                        .navigationBarBackButtonHidden(true),
                                    isActive: $detailsViewIsActive){
                                    Workout(workout: workout, refreshWorkouts: $refreshWorkouts)
                                        .padding(.horizontal,10)
                                }
                                .buttonStyle(PlainButtonStyle())
        
                                }
                            }
                        }
                    
                    Spacer()
                }
                .refreshable {
                    Task{
                        try await workoutViewModel.fetchWorkoutsDescendingByDate()
                    }
                }
                .navigationTitle("Workouts 🏋️")
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
                Alert(title: Text("Workout logged!"),
                      message: Text("Your workout has been successfully saved."),
                      dismissButton: .default(Text("OK")))
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
        .onChange(of: refreshWorkouts){
            Task{
                try await workoutViewModel.fetchWorkoutsDescendingByDate()
            }
            refreshWorkouts.toggle()
        }
    }
}

extension Workouts {
    var filteredWorkouts: [DBWorkout] {
        let calendar = Calendar.current
        let today = Date()
        if calendar.isDate(selectedDate, inSameDayAs: today) {
            return workoutViewModel.workouts
        } else {
            return workoutViewModel.workouts.filter { workout in
                calendar.isDate(workout.date, equalTo: selectedDate, toGranularity: .day)
            }
        }
    }
}

#Preview {
    Workouts()
        .environmentObject(ProfileViewModel())
        .environmentObject(WorkoutViewModel())
}
