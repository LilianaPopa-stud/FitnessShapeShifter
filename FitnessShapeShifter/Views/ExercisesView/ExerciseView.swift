//
//  ExerciseView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 29.03.2024.
//

import SwiftUI

struct ExerciseView: View {
    @State var exercise: DBExercise
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // name of the  exercise
            
            VStack {
                Text("\(exercise.name)")
                    .font(Font.custom("Bodoni 72", size: 30, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                
                HStack {
                    VStack {
//                        HStack {
//                            Text("Primary")
//                                .font(.caption)
//                            .padding(.top, 10)
//                            Spacer()
//                        }
//                        .padding(.leading,40)
                        ForEach(exercise.primaryMuscle, id: \.self) { muscle in
                            HStack {
                                Text(muscle)
                                    .font(.system(size: 15))
                                    .padding(.vertical,5)
                                    .padding(.horizontal,10)
                                    .background(Color.accentColor1)
                                    .cornerRadius(10)
                                .foregroundColor(.white)
                               // Spacer()
                            }
                            .padding(.leading,40)
                        }
                        
                        ForEach(exercise.secondaryMuscle ?? [], id: \.self) { muscle in
                            HStack {
                                Text(muscle)
                                    .font(.system(size: 15))
                                    .padding(.vertical,5)
                                    .padding(.horizontal,10)
                                    .background(Color.accentColor1.opacity(0.5))
                                    .cornerRadius(10)
                                .foregroundColor(.white)
                           // Spacer()
                            }
                            .padding(.leading,40)
                        }
                    }
                    ZStack {
                        ForEach(exercise.primaryMuscle + (exercise.secondaryMuscle ?? []), id: \.self) { muscle in
                            Image(imageName(for: muscle))// Replace with your muscle image
                                .resizable()
                                .frame(width: 200, height: 200) // Adjust size as needed
                                .foregroundColor(.red) // Adjust color as needed
                        }
                      
                    }
                }
                Spacer()
            }
        }
    }
    func imageName(for muscle: String) -> String {
        switch muscle {
        case "Biceps":
            return "Biceps"
        case "Triceps":
            return "Triceps"
        case "Chest":
            return "Chest"
        case "Inner Chest":
            return "Chest"
        case "Lower Chest":
            return "Chest"
        case "Upper Chest":
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
            // Add more cases for other muscles as needed
        default:
            return "none"
        }
    }
}

#Preview {
    ExerciseView(exercise: DBExercise())
}
