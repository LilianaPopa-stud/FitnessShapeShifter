//
//  Workout.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.
//



import SwiftUI

struct Workout: View {
    var workout: DBWorkout
    @EnvironmentObject var workoutViewModel: WorkoutViewModel
    @State var exercises: [(ExerciseInWorkout,DBExercise)] = []
    var body: some View {
        // title
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            VStack {
                
                HStack {
                    Text("\(workout.title)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    //button
                    Button(action: {}, label:
                            {Image(systemName: "ellipsis")
                        .font(.title2)} )
                }
                HStack{
                    Text(workout.date, style: .date)
                        .foregroundStyle(.gray)
                    Text("at ").foregroundStyle(.gray) + Text(workout.date, style: .time).foregroundStyle(.gray)
                    Spacer()
                }
                Divider()
                    .frame(height: 1)
                    .overlay(.accentColor2)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        VStack {
                            Text("Duration")
                                .font(.caption)
                            Text("\(formattedDuration)")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal,20)
                        
                        Divider()
                            .frame(width: 1)
                            .overlay(.accentColor2)
                        
                        
                        VStack {
                            Text("KCal")
                                .font(.caption)
                            Text("\(workout.totalCalories)")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal,20)
                        
                        Divider()
                            .frame(width: 1)
                            .overlay(.accentColor2)
                        
                        
                        VStack {
                            Text("TVL")
                                .font(.caption)
                            Text("\(String(format: "%.f",workout.totalWeight)) kg")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal,20)
                        Divider()
                            .frame(width: 1)
                            .overlay(.accentColor2)
                        VStack {
                            Text("Sets")
                                .font(.caption)
                            Text("\(workout.totalSets)")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal,20)
                        Divider()
                            .frame(width: 1)
                            .overlay(.accentColor2)
                        VStack {
                            Text("Reps")
                                .font(.caption)
                            Text("\(workout.totalReps)")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal,20)
                    }
                    .frame(height: 20)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                Divider()
                    .frame(height: 1)
                    .overlay(.accentColor2)
                    .padding(.bottom,30)
                
                ForEach(exercises, id: \.0.id) { exercise in
                    VStack {
                        HStack {
                            Text(exercise.1.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                            
                        }
                        
                    }
                    
                }
                //
                // images
                ZStack{
                    ForEach(exercises, id: \.0.id){ exercise in
                        let muscle = exercise.1.primaryMuscle
                        ForEach(muscle, id: \.self) { muscle in
                            Image("\(imageName(for: muscle))")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 5)
                        }
//                        let muscle2 = exercise.1.secondaryMuscle
//                        ForEach(muscle2 ?? "none", id: \.self) { muscle in
//                            Image("\(imageName(for: muscle))")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 30, height: 30)
//                                .padding(.trailing, 5)
//                        }
                    }
                    
                }
                //
                Spacer()
                
            }
            .padding()
        }
        .onAppear(){
            Task{
                exercises = try await workoutViewModel.getWorkoutExercises(workout: workout)
            }
        }
        
        
    }
    
    
}

//MARK: - Functions
extension Workout{
    private var formattedDuration: String {
        let hours = Int(workout.duration) / 3600
        let minutes = (Int(workout.duration) % 3600) / 60
        let seconds = Int(workout.duration) % 60
        
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
    Workout(workout: DBWorkout())
        .environmentObject(WorkoutViewModel())
        .previewLayout(.sizeThatFits)
        .padding()
    
}
