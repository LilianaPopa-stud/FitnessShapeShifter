//
//  ExerciseListView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 05.04.2024.
//

import SwiftUI

struct ExerciseListView: View {
//    @State private var selectedExercises = Set<DBExercise>()
    @Binding var returnSelectedExercises: [DBExercise]
    @State var selectedExercises: Set<DBExercise> =  Set<DBExercise>()
    @State private var exercises: [DBExercise] = []
    @StateObject var viewModel = ExerciseViewModel()
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var selectedMuscleGroup: String? = nil
    @State private var selectedEquipment: String? = nil
    @Binding var showExerciseList: Bool
    
    
    private var filteredExercises: [String: [DBExercise]] {
        let sortedExercises = viewModel.exercises.sorted { $0.name < $1.name }
        return Dictionary(grouping: sortedExercises, by: { String($0.name.prefix(1)).uppercased() })
    }
    private var filteredExercisesForSearch: [DBExercise] {
          if searchText.isEmpty {
              return exercises
          } else {
              return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
          }
      }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Menu {
                        Button("All") {
                            selectedMuscleGroup = nil
                        }
                        ForEach(viewModel.muscleGroups, id: \.self) { muscleGroup in
                            Button(muscleGroup) {
                                selectedMuscleGroup = muscleGroup
                            }
                        }
                    } label: {
                        if let selectedMuscleGroup = selectedMuscleGroup {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .foregroundColor(.accentColor2)
                                .frame(width: 22, height: 22)
                                .padding(.trailing, 6)
                            Text(selectedMuscleGroup)
                                .foregroundColor(.primary)
                        } else {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .foregroundColor(.accentColor2)
                                .frame(width: 22, height: 22)
                                .padding(.trailing, 6)
                            Text("All Muscle Groups")
                                .foregroundColor(.secondary)
                        }
                        
                    }
                    .padding(.leading,20)
                    Spacer()
                    Menu {
                        Button("All") {
                            selectedEquipment = nil
                        }
                        ForEach(viewModel.equipmentTypes, id: \.self) { equipment in
                            Button(equipment) {
                                selectedEquipment = equipment
                            }
                        }
                    } label: {
                        if let selectedEquipment = selectedEquipment {
                            Image(systemName: "dumbbell.fill")
                                .foregroundColor(.accentColor2)
                                .frame(width: 22, height: 22)
                                .padding(.trailing, 6)
                            Text(selectedEquipment)
                                .foregroundColor(.primary)
                        } else {
                            Image(systemName: "dumbbell")
                                .foregroundColor(.accentColor2)
                                .frame(width: 22, height: 22)
                                .padding(.trailing, 6)
                            Text("All Equipment")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.trailing,20)
                }
                List {
                    if searchIsActive {
                        ForEach(filteredExercisesForSearch, id: \.self) { exercise in
                            if applyFilters(exercise: exercise) {
                                ExerciseRow(exercise: exercise, isSelected: selectedExercises.contains(exercise)) {
                                    if selectedExercises.contains(exercise) {
                                        selectedExercises.remove(exercise)
                                    } else {
                                        selectedExercises.insert(exercise)
                                    }
                                }
                            }
                        }
                    } else {
                        ForEach(filteredExercises.keys.sorted(), id: \.self) { key in
                            if shouldShowSectionHeader(key: key) {
                                Section(header: Text(key)) {
                                    ForEach(filteredExercises[key]!, id: \.self) { exercise in
                                        if applyFilters(exercise: exercise) {
                                            ExerciseRow(exercise: exercise, isSelected: selectedExercises.contains(exercise)) {
                                                if selectedExercises.contains(exercise) {
                                                    selectedExercises.remove(exercise)
                                                } else {
                                                    selectedExercises.insert(exercise)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    Task {
                        await viewModel.fetchExercises()
                        exercises = viewModel.exercises
                    }
                }
            }
            .navigationTitle("Select Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") { 
                showExerciseList = false
            }, trailing: Button("Done") {
                returnSelectedExercises.append(contentsOf: selectedExercises)
                showExerciseList = false
                
            })
        }
        .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Search")
        .onAppear {
            Task {
                await viewModel.fetchExercises()
                exercises = viewModel.exercises
                
            }
        }
    }
    func shouldShowSectionHeader(key: String) -> Bool {
        return filteredExercises[key]?.contains(where: { applyFilters(exercise: $0) }) ?? false
    }
    func applyFilters(exercise: DBExercise) -> Bool {
        return (selectedEquipment == nil || exercise.equipment == selectedEquipment) &&
        (selectedMuscleGroup == nil ||
         exercise.primaryMuscle.contains { $0 == selectedMuscleGroup } ||
         (exercise.secondaryMuscle?.contains { $0 == selectedMuscleGroup } ?? false))
    }
}


struct ExerciseRow: View {
    let exercise: DBExercise
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
            else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleSelection()
        }
    }
}
#Preview {
    ExerciseListView(/*selectedExercises: .constant(Set<DBExercise>())*/returnSelectedExercises: .constant([DBExercise]()),showExerciseList: .constant(true))
}
