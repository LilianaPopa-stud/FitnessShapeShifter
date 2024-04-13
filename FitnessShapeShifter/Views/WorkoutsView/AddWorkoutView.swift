//
//  AddWorkoutView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 05.04.2024.
//

import SwiftUI
import UIKit


struct AddWorkoutView: View {
    
    @StateObject var viewModel = AddWorkoutViewModel()
    @State private var isTimerRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var showExerciseList = false
    @State private var selectedExercises = [DBExercise]()
    @State private var tuples: [Exercise] = []
    @State private var isAlertShowing = false
    @State private var isSetEditingPresented = false
    @State private var exerciseSet: ExerciseSet = ExerciseSet(reps: 0, weight: 0.0)
    @State private var indexOfSet: Int = 0
    @State private var indexOfExercise: Int = 0
    @State private var isShowingModal = false // State to control modal presentation
    @State private var workoutTitle = "" // Added state for workout title
    @State private var startDate = Date()
    @State private var endDate = Date()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            AppBackground()
            
            NavigationView {
                VStack {
                    HStack{
                        Button(action: {
                            isTimerRunning = false
                        }, label: {
                            Image(systemName: "xmark")
                                .tint(.white)
                                .font(.title3)
                        })
                        Spacer()
                        Text("\(formattedElapsedTime)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        Button(action: {
                            isTimerRunning = false
                            isShowingModal = true
                            endDate = Date()
                            
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
                    List{
                        ForEach(tuples.indices, id: \.self) { index in
                            ExerciseDetails(exercises: $selectedExercises,
                            exercise: tuples[index].exercise,
                            sets: $tuples[index].sets,
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
                        .padding(.bottom,10)
                    })
                    .sheet(isPresented: $showExerciseList) {
                        ExerciseListView(returnSelectedExercises: $selectedExercises, showExerciseList: $showExerciseList)
                        
                    }
                    
                }
                
            }
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
                                Text("Workout details")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                // day of the week, month, day, year
                                Text("\(startDate, formatter: DateFormatter.dayOfWeek), ")
                                    .font(.caption)
                                    .foregroundColor(.secondary) +
                                Text("\(startDate, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(startDate, style: .time) - \(endDate, style: .time)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                TextField("Workout Title", text: $workoutTitle)
//                                    .frame(width: 150)
                                .focused($isFocused)
                                    .padding()
                                    .onAppear(){
                                        isFocused = true
                                    }
                               
                                Button("Save workout") {
                                    // Perform save action here
                                    isShowingModal = false
                                }
                                .disabled(tuples.isEmpty || workoutTitle.isEmpty)
                                Button("Discard Workout") {
                                    isShowingModal = false
                                }
                                .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding()
                        }
               
            
        }
        .onChange(of: selectedExercises, {
            for exercise in selectedExercises {
                if !tuples.contains(where: { $0.exercise == exercise }) {
                    tuples.append(Exercise(exercise: exercise))
                }
            }
            for tuple in tuples {
                if !selectedExercises.contains(tuple.exercise) {
                    tuples.removeAll(where: { $0.exercise == tuple.exercise })
                }
            }
            
        })
        .onAppear {
            startTimer()
        }
        .sheet(isPresented: $isSetEditingPresented) {
            SetEditView(isSetEditingPresented: $isSetEditingPresented,
                        exerciseSet: $exerciseSet,
                        exerciseIndex: $indexOfExercise,
                        setIndex: $indexOfSet,
                        tuples: $tuples)
            .preferredColorScheme(.dark)
            .presentationDetents([.fraction(0.43)])
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func startTimer() {
        startDate = Date()
        isTimerRunning = true
        elapsedTime = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            elapsedTime += 1
        }
    }
   
    
    private var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
// Exercise - sets (tuple)
struct Exercise {
    var exercise: DBExercise
    var sets: [ExerciseSet] = [ExerciseSet(reps: 8, weight: 10)]
}
extension DateFormatter {
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}

#Preview {
    AddWorkoutView()
}
