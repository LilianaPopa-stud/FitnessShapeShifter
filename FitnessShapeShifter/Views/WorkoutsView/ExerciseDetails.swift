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
        //        VStack(alignment: .leading, spacing: 10) {
        //            HStack {
        //                Text(exercise.name)
        //                    .font(.headline)
        //                    .onTapGesture {
        //                        isExpanded.toggle()
        //                    }
        //                Spacer()
        //                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        //                    .onTapGesture {
        //                        isExpanded.toggle()
        //                    }
        //
        //            }
        //
        //            if isExpanded {
        
        Section {
            if isExpanded {
                HStack {
                    Text("Sets")
                        .font(.subheadline)
                        .frame(width: 50, alignment: .center)
                    Spacer()
                    Text("Reps")
                        .frame(width: 50, alignment: .center)
                    Spacer()
                    Text("Weight")
                        .frame(width: 100, alignment: .center)
                }
                .foregroundColor(.secondary)
                ForEach(sets.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .frame(width: 50, alignment: .center)
                        Spacer()
                        Text("\(sets[index].reps)")
                            .frame(width: 50, alignment: .center)
                        Spacer()
                        Text("\(sets[index].weight) kg")
                            .frame(width: 100, alignment: .center)
                    }
                    
                }
                Button{
                    withAnimation {
                        sets.append(ExerciseSet(reps: 12, weight: 20))
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Add Set")
                            .font(.headline)
                        Spacer()
                    }
                }
                .padding(.top,10)
            }
            
        } header: {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(.white)
                      .frame(height: 70)
                      .shadow(color: .shadow, radius: 4, x: 1, y: 3)

                HStack {
                    Text(exercise.name)
                        .font(.headline)
                       
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        
                }
                
                .padding()
                //.foregroundColor(.white)
            }
            
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.8)){
                    isExpanded.toggle()
                }}
            
        }
        .foregroundColor(.black)
        
    }
}
struct ExerciseSet {
    var reps: Int
    var weight: Int
}


#Preview {
    ExerciseDetails(exercise: DBExercise())
}
