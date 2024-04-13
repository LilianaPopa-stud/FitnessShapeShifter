//
//  exerciseDetails.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 06.04.2024.
//

import SwiftUI

struct ExerciseDetails: View {
    @Binding var exercises: [DBExercise]
    let exercise: DBExercise
    @Binding var sets: [ExerciseSet] /*= [ExerciseSet(reps: 12, weight: 20),ExerciseSet(reps: 10, weight: 120),ExerciseSet(reps: 10, weight: 30),ExerciseSet(reps: 10, weight: 40),ExerciseSet(reps: 10, weight: 80)]*/
    @State private var isAlertShowing = false
    @State private var isExpanded = false
    @Binding var isSetEditingPresented: Bool
    @Binding var index: Int
    @Binding var exerciseIndex: Int
    
    var body: some View {
        Section {
            if isExpanded {
                HStack {
                    Text("Set")
                        .font(.subheadline)
                        .frame(width: 50, alignment: .center)
                    Spacer()
                    Text("Reps")
                        .frame(width: 50, alignment: .center)
                    Spacer()
                    Text("Weight")
                        .frame(width: 100, alignment: .center)
                }
                .padding(.bottom,5)
                .padding(.top,5)
                .foregroundColor(.secondary)
                ForEach(sets.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .frame(width: 50, alignment: .center)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        Text("\(sets[index].reps)")
                            .frame(width: 50, alignment: .center)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(String(format: "%.1f", sets[index].weight)) kg")
                            .frame(width: 100, alignment: .center)
                            .fontWeight(.semibold)
                    }
                    .onTapGesture {
                        self.isSetEditingPresented = true
                        self.index = index
                        
                        
                        
                        
                        
                    }
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
                
                Button{
                    withAnimation {
                        sets.append(sets.last ?? ExerciseSet(reps: 8, weight: 10))
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(height: 50)
                            .shadow(color: .shadow, radius: 4, x: 1, y: 3)
                        HStack {
                            Spacer()
                            Text("Add Set")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                .padding(.top,10)
            }
            
        }
    header: {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(.white)
                .frame(height:100)
                .shadow(color: .shadow, radius: 4, x: 1, y: 3)
            
            
            HStack {
                //image placeholder
                Group {
                    ZStack {
                        
                        ForEach(exercise.primaryMuscle, id: \.self) { muscle in
                            
                            Image(imageName(for: muscle))// Replace with your muscle image
                                .resizable()
                                .frame(width: 70, height: 70)
                            Image(imageName(for: muscle))
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                        ForEach(exercise.secondaryMuscle ?? [], id: \.self) { muscle in
                            Image(imageName(for: muscle))
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                    }
                    
                    //                    Image("wide-grip-lat-pulldown")
                    //                        .resizable()
                    //                        .scaledToFit()
                    //                        .frame(maxWidth: 90, maxHeight: 90)
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(exercise.name)
                                .font(.headline)
                            //   Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        }
                        
                        
                        HStack {
                            
                            Text("\(sets.count) sets")
                                .foregroundStyle(.secondary)
                            //                            Divider()
                            //                                .frame(width: 1, height: 20)
                            //                                .overlay(.secondary)
                            Text("•")
                                .foregroundStyle(.secondary)
                            if (sets.count != 0){
                                if (computeRepsRange().max==computeRepsRange().min){
                                    Text("\(computeRepsRange().min) reps")
                                        .foregroundStyle(.secondary)
                                }
                                else { Text("\(computeRepsRange().min)-\(computeRepsRange().max) reps")
                                        .foregroundStyle(.secondary)
                                }
                                Text("•")
                                    .foregroundStyle(.secondary)
                                if (computeWeightRange().max==computeWeightRange().min){
                                    Text("\(String(format:"%.f",computeWeightRange().min)) kg")
                                        .foregroundStyle(.secondary)
                                }
                                else {
                                    Text("\(String(format:"%.f",computeWeightRange().min))-\(String(format:"%.f",computeWeightRange().max)) kg")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.8)){
                        isExpanded.toggle()
                    }}
                
                Spacer()
                VStack {
                    Menu {
                        Button {
                            withAnimation {
                                isExpanded = true
                            }
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive){
                            withAnimation {
                                isAlertShowing.toggle()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    } label: {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .frame(width: 10, height: 35)
                            Image(systemName: "ellipsis")
                                .foregroundColor(.accentColor2)
                        }
                    }
                    
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding(.bottom,30)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.8)){
                                isExpanded.toggle()
                            }}
                    
                }
                .frame(height: 100)
                
            }
            
            .padding(.horizontal,10)
            //.foregroundColor(.white)
        }
        
        
        
    }
        
    .alert(isPresented: $isAlertShowing) {
        Alert(
            title: Text("Delete Exercise"),
            message: Text("Are you sure you want to delete this exercise? This action cannot be undone."),
            primaryButton: .destructive(Text("Delete")) {
                exercises.removeAll { $0.id == exercise.id }
            },
            secondaryButton: .cancel()
        )
    }
    .foregroundColor(.black)
    }
}

extension ExerciseDetails {
    func moveItems(from source: IndexSet, to destination: Int) {
        sets.move(fromOffsets: source, toOffset: destination)
        print("Moved from \(source) to \(destination)")
        
    }
    
    func imageName(for muscle: String) -> String {
        switch muscle {
        case "Biceps":
            return "Biceps"
        case "Triceps":
            return "Triceps"
        case "Chest", "Inner Chest", "Lower Chest", "Upper Chest":
            return "Chest"
        case "Lats":
            return "Lats"
        case "Abdominalis":
            return "Abdominalis"
        case "Quadriceps":
            return "Quads"
        case "Hamstrings":
            return "Hamstrings"
        case "Shoulders":
            return "Deltoid"
        case "Front Shoulders":
            return "Deltoid"
        case "Traps":
            return "Traps"
        case "Calves":
            return "Calves"
        case "Glutes":
            return "Glutes"
        case "Lower Back":
            return "Lowerback"
        case "Forearms":
            return "Forearm"
        case "Obliques":
            return "Obliques"
        case "Adductors":
            return "Adductor"
        default:
            return "none"
        }
    }
    func deleteItems(at offsets: IndexSet) {
        sets.remove(atOffsets: offsets)
    }
    func computeRepsRange() -> (min: Int, max: Int){
        var reps: Int
        var minRep: Int = Int.max
        var maxRep: Int = Int.min
        
        for set in sets {
            reps = set.reps
            if reps < minRep {
                minRep = reps
            }
            if reps > maxRep {
                maxRep = reps
            }
        }
        return (minRep, maxRep)
        
    }
    func computeWeightRange() -> (min: Double, max: Double){
        var weight: Double
        var minWeight: Double = Double(Int.max)
        var maxWeight: Double = Double(Int.min)
        
        for set in sets {
            weight = set.weight
            if weight < minWeight {
                minWeight = weight
            }
            if weight > maxWeight {
                maxWeight = weight
            }
        }
        return (minWeight, maxWeight)
    }
    
}

struct ExerciseSet {
    var reps: Int
    var weight: Double
}


#Preview {
    ExerciseDetails(exercises:.constant([DBExercise(),DBExercise()]),exercise: DBExercise(), sets: .constant([ExerciseSet(reps: 10, weight: 10)]), isSetEditingPresented: .constant(false), index: .constant(1),exerciseIndex:.constant(1))
}
