//
//  AddWorkoutView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 05.04.2024.
//

import SwiftUI
import UIKit


struct AddWorkoutView: View {
    
    @State private var isTimerRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var showExerciseList = false
    @State private var selectedExercises = [DBExercise]()
    @State private var tuples: [Exercise] = []
    @State private var sets: [ExerciseSet] = [ExerciseSet(reps: 8, weight: 10)]
    @State private var isAlertShowing = false
    @State private var isSetEditingPresented = false
    @State private var exerciseSet: ExerciseSet = ExerciseSet(reps: 0, weight: 0)
    
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
                        ForEach(selectedExercises.sorted(by: { $0.name < $1.name }), id: \.self) { exercise in
                            ExerciseDetails(exercises: $selectedExercises, exercise: exercise, isSetEditingPresented: $isSetEditingPresented)
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
            
        }
        .onChange(of: selectedExercises, {
            tuples = selectedExercises.map { Exercise(exercise: $0) }
   
        })
        .onAppear {
            startTimer()
        }
        .sheet(isPresented: $isSetEditingPresented) {
            SetEditView(isSetEditingPresented: $isSetEditingPresented, exerciseSet: $exerciseSet)
                .preferredColorScheme(.dark)
                .presentationDetents([.fraction(0.43)])
                .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func startTimer() {
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
    var sets: [ExerciseSet] = [ExerciseSet(reps: 8, weight: 0)]
}

#Preview {
    AddWorkoutView()
}
