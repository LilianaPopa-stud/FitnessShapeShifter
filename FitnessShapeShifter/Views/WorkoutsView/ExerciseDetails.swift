//
//  exerciseDetails.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 06.04.2024.
//

import SwiftUI

struct ExerciseDetails: View {
    let exercise: DBExercise
    @State private var sets: [ExerciseSet] = [ExerciseSet(reps: 12, weight: 2),ExerciseSet(reps: 10, weight: 200),ExerciseSet(reps: 8, weight: 300),ExerciseSet(reps: 6, weight: 400),ExerciseSet(reps: 4, weight: 500)]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(exercise.name)
                    .font(.headline)
                    .onTapGesture {
                        isExpanded.toggle()
                }
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .onTapGesture {
                        isExpanded.toggle()
                    }
                Spacer()
            }
            
            if isExpanded {
                ForEach(sets.indices, id: \.self) { index in
                    VStack {
                        HStack {
                            Text("Set \(index + 1)")
                                .font(.subheadline)
                            Spacer()
                            Text("Reps: \(sets[index].reps)")
                            Spacer()
                            Text("Weight: \(sets[index].weight) kg")
                        }
                    }
                }
                Button("Add Set") {
                    let newSet = ExerciseSet(reps: 0, weight: 0)
                    sets.append(newSet)
                }
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(.accentColor2)
     
    }
       

}
struct ExerciseSet {
    var reps: Int
    var weight: Int
}


#Preview {
    ExerciseDetails(exercise: DBExercise())
}
