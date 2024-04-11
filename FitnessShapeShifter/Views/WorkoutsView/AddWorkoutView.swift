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
                             ExerciseDetails(exercise: exercise)
                                .padding(.top,-20)
                                
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
                        .padding(.bottom,40)
                    })
                    .sheet(isPresented: $showExerciseList) {
                        ExerciseListView(returnSelectedExercises: $selectedExercises, showExerciseList: $showExerciseList)
                    }
                    
                    
                    
                    
                    
                }
                //                .toolbar{
                ////                    ToolbarItem(placement: .principal){
                ////                        Text("\(formattedElapsedTime)")
                ////                            .font(.headline)
                ////                            .foregroundColor(.white)
                ////                    }
                //                    ToolbarItem(placement: .navigationBarLeading){
                //                        Button(action: {
                //                            isTimerRunning = false
                //                        }, label: {
                //                            Image(systemName: "xmark")
                //                                .tint(.white)
                //                        })
                //                    }
                //                    ToolbarItem(placement: .navigationBarTrailing){
                //                        Button(action: {
                //                            isTimerRunning = false
                //                        }, label: {
                //                            Image(systemName: "checkmark.circle.fill")
                //                                .tint(.white)
                //                        })
                //                    }
                //                }
            }
            
        }
        .onAppear {
            startTimer()
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

#Preview {
    AddWorkoutView()
}