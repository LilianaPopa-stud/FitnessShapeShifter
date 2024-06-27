//
//  EditWorkoutView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 22.04.2024.
//

import SwiftUI

struct EditWorkoutView: View {
    @StateObject var viewModel = WorkoutViewModel()
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Binding var workout: DBWorkout
    @State private var showExerciseList = false
    @State private var selectedExercises = [DBExercise]()
    @State private var alreadyLoggedExercises: [DBExercise] = []
    @State private var isAlertShowing = false
    @State private var isSetEditingPresented = false
    @State private var exerciseSet: ExerciseSet = ExerciseSet(reps: 0, weight: 0.0)
    @State private var indexOfSet: Int = 0
    @State private var indexOfExercise: Int = 0
    @State private var isShowingModal = false
    @State private var endDate = Date()
    @FocusState private var isFocused: Bool
    @Binding var viewIsActive: Bool
    
    var body: some View {
        ZStack {
            AppBackground()
            NavigationView {
                VStack {
                    HStack{
                        Button(action: {
                            viewIsActive = false
                        }, label: {
                            Image(systemName: "xmark")
                                .tint(.white)
                                .font(.title3)
                        })
                        
                        Spacer()
                        Button(action: {
                            isShowingModal = true
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                                .tint(.white)
                                .font(.title3)
                        })
                    }
                    .ignoresSafeArea(edges: .top)
                    .padding(.horizontal,20)
                    .padding(.bottom,30)
                    .frame(height: 80)
                    .background(.black)
                    
                    List {
                        ForEach(viewModel.tuples.indices, id: \.self) { index in
                            ExerciseDetails(
                                exercises: $selectedExercises,
                                exercise: viewModel.tuples[index].exercise,
                                sets: $viewModel.tuples[index].sets,
                                isSetEditingPresented: $isSetEditingPresented,
                                index: $indexOfSet,
                                exerciseIndex: $indexOfExercise)
                            .padding(.top,-10)
                        }
                    }
                    .listSectionSpacing(.custom(0))
                    .listStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    Spacer()
                    Button(action: { showExerciseList = true }, label: {
                        VStack {
                            HStack {
                                Text("Add Exercise")
                                    .font(.headline)
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                            }
                        }
                        .font(.headline)
                        .font(Font.custom("RobotoCondensed-Bold", size: 18))
                        .foregroundColor(.accentColor2)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.accentColor2, lineWidth: 2)
                                .shadow(color: .shadow, radius: 4, x: 1, y: 3))
                        .padding(.horizontal,60)
                        .padding(.bottom,30)
                    })
                    //MARK: ExerciseList sheet
                    .sheet(isPresented: $showExerciseList) {
                        ExerciseListView(returnSelectedExercises: $selectedExercises, showExerciseList: $showExerciseList)
                        
                    }
                    
                }
                
            }
            //MARK: Modal
            if isShowingModal {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            isShowingModal = false
                        }, label: {
                            Image(systemName: "xmark")
                                .tint(.secondary)
                                .font(.caption)
                        })
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        Spacer()
                    }
                    
                    HStack {
                        Text("\(workout.title)")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding(.vertical,5)
                    HStack {
                        Text("💪 TVL: \(String(format: "%.f",totalValueKg())) kg ")
                    }
                    .padding(.bottom,5)
                    HStack {
                        Text("\(selectedExercises.count) exercises ")
                        Text("\(countSets()) sets ")
                        Text("\(countReps()) reps ")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom,5)
                    VStack {
                        Button(action: {
                            Task {
                                viewModel.totalReps = countReps()
                                viewModel.totalSets = countSets()
                                viewModel.totalValueKg = totalValueKg()
                                await viewModel.updateWorkout(workout: workout)
                                isShowingModal = false
                                viewIsActive = false
                            }
                            
                            
                        }, label: {
                            Text("Update")
                        })
                        .padding(.bottom,5)
                        .disabled(viewModel.tuples.isEmpty)
                        Button("Cancel",role: .destructive) {
                            isShowingModal = false
                            viewIsActive = false
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding()
            }
        }
        .onChange(of: selectedExercises, {
            for exercise in selectedExercises {
                if !viewModel.tuples.contains(where: { $0.exercise == exercise }) {
                    viewModel.tuples.append(Exercise(exercise: exercise))
                }
            }
            for tuple in viewModel.tuples {
                if !selectedExercises.contains(tuple.exercise) {
                    viewModel.tuples.removeAll(where: { $0.exercise == tuple.exercise })
                }
            }
            
        })
        .onAppear {
            for tuple in viewModel.tuples {
                selectedExercises.append(
                    tuple.exercise
                )}
        }
        
        
        //MARK: SetEditView sheet
        .sheet(isPresented: $isSetEditingPresented) {
            SetEditView(isSetEditingPresented: $isSetEditingPresented,
                        exerciseSet: $exerciseSet,
                        exerciseIndex: $indexOfExercise,
                        setIndex: $indexOfSet,
                        tuples: $viewModel.tuples)
            .presentationDetents([.fraction(0.43)])
            .ignoresSafeArea(edges: .bottom)
        }
        
    }
    //MARK: Other properties
    
}
extension EditWorkoutView {
    
    func countSets() -> Int {
        var count = 0
        for tuple in viewModel.tuples {
            count += tuple.sets.count
        }
        return count
    }
    
    func countReps()->Int{
        var count = 0
        for tuple in viewModel.tuples {
            for set in tuple.sets {
                count += set.reps
            }
        }
        return count
    }
    
    func totalValueKg()->Double{
        
        var total = 0.0
        for tuple in viewModel.tuples {
            for set in tuple.sets {
                total += set.weight * Double(set.reps)
            }
        }
        return total
    }
    
    func burnedCalories()-> Double {
        let minutes =  viewModel.elapsedTime/60
        guard let weight = profileViewModel.user?.weight else {
            return 0
        }
        if profileViewModel.user?.gender == "Female"{
            let calories = minutes * weight * 0.0637
            return Double(calories)}
        else {
            
            let calories = minutes * weight * 0.0713
            return Double(calories)}
    }
    
    
    
}

#Preview {
    EditWorkoutView(workout: .constant(DBWorkout()), viewIsActive: .constant(true))
        .environmentObject(ProfileViewModel())
        .environmentObject(WorkoutViewModel())
}
