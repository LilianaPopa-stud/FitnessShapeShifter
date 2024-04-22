//
//  ExercisesRow.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 20.04.2024.
//

import SwiftUI

struct ExerciseItem: View {
    var exercise: (ExerciseInWorkout,DBExercise)
    @State var sets: [ExerciseSet] = []
    @State private var isExpanded = false
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
                            .frame(width: 80, alignment: .center)
                    }
                    .onAppear {
                        sets = exercise.0.sets
                    }
                    .padding(.bottom,5)
                    .padding(.top,5)
                   // .padding(.leading,20)
                    .foregroundColor(.gray)
                    
                    ForEach(sets.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                                .frame(width: 50, alignment:  .center)
                            Spacer()
                            Text("\(sets[index].reps)")
                                .frame(width: 50, alignment: .center)
                            Spacer()
                            Text(String(format:"%.1f kg",sets[index].weight))
                                .frame(width: 80, alignment: .center)
                        }
                        .padding(.bottom,5)
                        .padding(.top,5)
                       // .padding(.leading,20)
                       // .foregroundColor(.black)
                       
                        
                    }
                    .onDelete(perform: { indexSet in
                       print("delete")
                    })
                }
                

                
            
        } header: {
            Group {
                VStack {
                    HStack {
                        Text(exercise.1.name)
                            .font(.title3)
                            .bold()
                           // .padding(.leading,20)
                        Spacer()
                        Button(action: {
                            isExpanded.toggle()
                        }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .padding(.trailing,10)
                        }
                        
                    }
                    HStack {
                        if exercise.0.sets.count == 1 {
                            Text("\(exercise.0.sets.count) set")
                        } else {
                            Text("\(exercise.0.sets.count) sets")
                        }
                        if exercise.0.sets.count > 0 {
                            Text(" • ")
                        }
                        Text("\(exercise.0.sets.reduce(0, { $0 + $1.reps })) reps")
                        Spacer()
                    }
                    .foregroundColor(.gray)
                    //.padding(.leading,20)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
            }
           
        }

    }
}

#Preview {
    ExerciseItem(exercise: (ExerciseInWorkout(),DBExercise()))
}
