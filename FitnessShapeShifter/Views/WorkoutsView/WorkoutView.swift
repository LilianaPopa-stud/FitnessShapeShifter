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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var exercises: [(ExerciseInWorkout,DBExercise)] = []
    @State private var isDeleteAlertPresented = false
    @Binding var refreshWorkouts: Bool
    @State var isLoading = true

    var body: some View {
        // title
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            VStack {
                HStack {
                    CircularProfileImage(imageState: profileViewModel.imageState, size:  CGSize(width: 45, height: 45))
                        
                    Text("\(workout.title)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    //button
                    // edit and delete buttons
                    Menu {
                        Button {
                            withAnimation {
                             
                            }
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive){
                            isDeleteAlertPresented = true
                            
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
                                .font(.title2)
                        }
                    }
                    .alert(isPresented: $isDeleteAlertPresented) {
                        Alert(
                            title: Text("Delete workout"),
                            message: Text("Are you sure you want to delete this workout? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                Task {
                                    await workoutViewModel.deleteWorkout(workoutId: workout.id)
                                        }
                                refreshWorkouts.toggle()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                HStack{
                    Text(workout.date, style: .date)
                        .foregroundStyle(.gray)
                    Text("at ").foregroundStyle(.gray) + Text(workout.date, style: .time).foregroundStyle(.gray)
                    Spacer()
                }
                Divider()
                    .frame(height: 1)
                    .overlay(.gray)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        HStack {
                            WorkoutStatView(title: "Duration", value: formattedDuration)
                            WorkoutStatView(title: "Exercises", value: String(workout.exercises.count))
                            WorkoutStatView(title: "TVL", value: "\(String(format: "%.f", workout.totalWeight)) kg")
                            WorkoutStatView(title: "Calories", value: "\(workout.totalCalories)")
                            WorkoutStatView(title: "Sets", value: "\(workout.totalSets)")
                            WorkoutStatView(title: "Reps", value: "\(workout.totalReps)")
                        }
                    }
                    .frame(height: 20)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                Divider()
                    .frame(height: 1)
                    .overlay(.gray)
                    .padding(.bottom,10)
                
                if isLoading{
                    
                    ProgressView()
                        .padding(.top,50)
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    
                    
                    } else {
                        HStack{
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(getDistinctMuscles(), id: \.self) { muscle in
                                    Text(muscle)
                                        .font(.caption)
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .background(Color.accentColor2)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 120, height: 160)
                
                            
                            ZStack{
                                ForEach(exercises, id: \.0.id){ exercise in
                                    let muscle = exercise.1.primaryMuscle
                                    let muscle2 = exercise.1.secondaryMuscle
                                    ForEach(muscle, id: \.self) { muscle in
                                        Image("\(workoutViewModel.imageName(for: muscle))")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200, height: 200)
                                            .padding(.trailing, 5)
                                    }
                                    ForEach(muscle2 ?? [], id: \.self) { muscle in
                                        Image("\(workoutViewModel.imageName(for: muscle))")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200, height: 200)
                                            .padding(.trailing, 5)
                                    }
                                }
                            }
                            
                        }}
                    Spacer()
                }
                .padding()
            
        }
        .onAppear(){
            Task {
                   do {
                       exercises = try await workoutViewModel.getWorkoutExercises(workout: workout)
                       isLoading = false
                   } catch {
                       print("Error fetching exercises for workout:", error)
                   }
               }
            
        }
        .onChange(of: isLoading){
            refreshWorkouts.toggle()
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
            return String(format: "%2dh %02dm", hours, minutes)
        }
    }
    
    func getDistinctMuscles() -> [String] {
        var muscles: [String] = []
        for exercise in exercises {
            for muscle in exercise.1.primaryMuscle {
                if !muscles.contains(muscle) {
                    muscles.append(muscle)
                }
            }
            if let secondaryMuscle = exercise.1.secondaryMuscle {
                for muscle in secondaryMuscle {
                    if !muscles.contains(muscle) {
                        muscles.append(muscle)
                    }
                }
            }
        }
        return muscles
    }

    
    
}

struct WorkoutStatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
            Text(value)
                .font(.system(size: 16))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        if title != "Reps" {
            Divider().frame(width: 1)
                .overlay(Color.gray)
        }
    }
}



#Preview {
    Workout(workout: DBWorkout(), refreshWorkouts: .constant(false))
        .environmentObject(WorkoutViewModel())
        .environmentObject(ProfileViewModel())
        .previewLayout(.sizeThatFits)
        .padding()
    
}
