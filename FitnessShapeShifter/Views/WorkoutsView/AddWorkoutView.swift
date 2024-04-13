//
//  AddWorkoutView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 05.04.2024.
//

import SwiftUI
import UIKit


struct AddWorkoutView: View {
    //MARK: Properties
    @StateObject var viewModel = AddWorkoutViewModel()
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var isTimerRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var showExerciseList = false
    @State private var selectedExercises = [DBExercise]()
    @State private var isAlertShowing = false
    @State private var isSetEditingPresented = false
    @State private var exerciseSet: ExerciseSet = ExerciseSet(reps: 0, weight: 0.0)
    @State private var indexOfSet: Int = 0
    @State private var indexOfExercise: Int = 0
    @State private var isShowingModal = false
    @State private var workoutTitle = ""
    @State private var endDate = Date()
    @FocusState private var isFocused: Bool
    @Binding var viewIsActive: Bool
    //MARK: Body
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
                            viewModel.elapsedTime = elapsedTime
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
                    Text("Workout details")
                        .font(.title2)
                        .foregroundColor(.black)
                    // day of the week, month, day, year
                    Text("\(viewModel.date, formatter: DateFormatter.dayOfWeek), ")
                        .font(.caption)
                        .foregroundColor(.secondary) +
                    Text("\(viewModel.date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(viewModel.date, style: .time) - \(endDate, style: .time)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField("Workout Title", text: $workoutTitle)
                        //  .background(.black)
                            .focused($isFocused)
                            .padding()
                            .onAppear(){
                                isFocused = true
                            }
                        
                        Spacer()
                    }
                    HStack {
                        Text("🕒 \(formattedDuration) ")
                        Text("💪 TVL: \(String(format: "%.f",totalValueKg())) kg ")
                    }
                    .padding(.bottom,5)
                    HStack{
                        
                        Text("\(selectedExercises.count) exercises ")
                        
                        Text("\(countSets()) sets ")
                        Text("\(countReps()) reps ")
                        
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom,5)
                    
                    
                    VStack {
                        
                        Button("Save workout") {
                            // Perform save action here
                            isShowingModal = false
                        }
                        .padding(.bottom,5)
                        .disabled(viewModel.tuples.isEmpty /*|| workoutTitle.isEmpty*/)
                        Button("Discard",role: .destructive) {
                            isShowingModal = false
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
            startTimer()
        }
//MARK: SetEditView sheet
        .sheet(isPresented: $isSetEditingPresented) {
            SetEditView(isSetEditingPresented: $isSetEditingPresented,
                        exerciseSet: $exerciseSet,
                        exerciseIndex: $indexOfExercise,
                        setIndex: $indexOfSet,
                        tuples: $viewModel.tuples)
            .preferredColorScheme(.dark)
            .presentationDetents([.fraction(0.43)])
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
   //MARK: Other properties
    private var formattedDuration: String {
        let hours = Int(viewModel.elapsedTime) / 3600
        let minutes = (Int(viewModel.elapsedTime) % 3600) / 60
        let seconds = Int(viewModel.elapsedTime) % 60
        
        if hours == 0 {
            if minutes != 0 {
                if minutes < 10 {
                    return String(format: "%dm %02ds", minutes, seconds)
                } else {
                    return String(format: "%02dm %02ds", minutes, seconds)
                }
            } else {
                return String(format: "%ds", seconds)
            }
        } else {
            return String(format: "%2dh %02dm %02ds", hours, minutes, seconds)
        }
    }
    
    
    private var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
//MARK: - FUNCTIONS
extension AddWorkoutView {
    private func startTimer() {
        viewModel.date = Date()
        isTimerRunning = true
        elapsedTime = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: isTimerRunning) { timer in
            elapsedTime += 1
        }
    }
    
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
    /*
     How Does This Weight Lifting Calorie Calculator Work?

     The calorie calculator uses these equations to estimate the caloric cost of weight training:

     Men: [Minutes working out] × [Bodyweight in kg] × 0.0713
     Women: [Minutes working out] × [Bodyweight in kg] × 0.0637
     */
    
    
    func saveWorkout(){
    }
}
//MARK: Exercise struct
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

//MARK: Preview
#Preview {
    AddWorkoutView(viewIsActive: .constant(true))
}
