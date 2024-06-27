//
//  ExerciseView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 29.03.2024.
//

import SwiftUI

struct ExerciseView: View {
    @State private var showFullDescription = false
    @State var exercise: DBExercise
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            VStack {
                Text("\(exercise.name)")
                    .font(Font.custom("Bodoni 72", size: 25, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                HStack{
                    VStack {
                        if let difficulty  = exercise.difficulty {
                            Text("Difficulty")
                                .font(.caption2)
                                .foregroundStyle(.black.opacity(0.6))
                            Text("\(difficulty)")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    Divider()
                        .frame(height: 20)
                    VStack {
                        if let force = exercise.force {
                            Text("Force")
                                .font(.caption2)
                                .foregroundStyle(.black.opacity(0.6))
                            Text("\(force)")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    Divider()
                        .frame(height: 20)
                    VStack {
                        if let mechanic = exercise.mechanic {
                            Text("Mechanic")
                                .font(.caption2)
                                .foregroundStyle(.black.opacity(0.6))
                            Text("\(mechanic)")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    Divider()
                        .frame(height: 20)
                    VStack {
                        if let equipment = exercise.equipment {
                            Text("Equipment")
                                .font(.caption2)
                                .foregroundStyle(.black.opacity(0.6))
                            Text("\(equipment)")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        ForEach(exercise.primaryMuscle, id: \.self) { muscle in
                            HStack {
                                if muscle != "None"{
                                    Text(muscle)
                                        .font(.system(size: 15))
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .background(Color.accentColor2)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        ForEach(exercise.secondaryMuscle ?? [], id: \.self) { muscle in
                            HStack {
                                if muscle != "None"{
                                    Text(muscle)
                                        .font(.system(size: 15))
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .background(Color.accentColor2.opacity(0.5))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    //muscle map
                    ZStack {
                        ForEach(exercise.primaryMuscle, id: \.self) { muscle in
                            
                            Image(imageName(for: muscle))
                                .resizable()
                                .frame(width: 200, height: 200)
                            Image(imageName(for: muscle))
                                .resizable()
                                .frame(width: 200, height: 200)
                        }
                        ForEach(exercise.secondaryMuscle ?? [], id: \.self) { muscle in
                            Image(imageName(for: muscle))
                                .resizable()
                                .frame(width: 200, height: 200)
                        }
                        
                    }
                }
                // description
                VStack {
                    if let description = exercise.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .lineLimit(showFullDescription ? nil : 2)
                            .opacity(showFullDescription ? 1 : 0.6)
                            .padding(.bottom, 10)
                            .onTapGesture {
                                showFullDescription.toggle()
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
        case "Chest", "Inner Chest", "Lower Chest", "Upper Chest":
            return "Chest"
        case "Lats":
            return "Lats"
        case "Abdominals":
            return "Abdominals"
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
    
}

#Preview {
    ExerciseView(exercise: DBExercise())
}
