//
//  WorkoutDetailsView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 19.04.2024.
//

import SwiftUI

struct WorkoutDetails: View {
    @State var exercises: [(ExerciseInWorkout,DBExercise)] = []
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var workoutViewModel: WorkoutViewModel
    @State private var isEditingMode = false
    @State private var isDeleteAlertPresented = false
    @State private var isEditWorkoutDetailsPresented = false
    @State private var isUpdatedWorkoutAlertPresented = false
    @State private var primaryMuscles: [String] = []
    @State private var secondaryMuscles: [String] = []
    @State private var workoutTitle: String = ""
    @State private var workoutDate: Date = Date()
    @Binding var isActive: Bool
    @State var workout: DBWorkout
   
    var body: some View {
        ZStack {
            AppBackground()
            NavigationView {
                GeometryReader { g in
                    ScrollView {
                        HStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 70)
                                .cornerRadius(5)
                                .padding(.horizontal, 15)
                                .overlay(
                                    HStack{
                                        CircularProfileImage(imageState: profileViewModel.imageState, size: CGSize(width: 50, height: 50))
                                            .padding(.leading,20)
                                            .padding(.trailing,10)
                                            .padding(.top,10)
                                        VStack(alignment: .leading) {
                                            Text(profileViewModel.user?.displayName ?? "Username")
                                            
                                                .fontWeight(.semibold)
                                                .font(.system(size: 15))
                                            Text("\(formatDate(date: workout.date))")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12))
                                        }
                                        .foregroundColor(.black)
                                        Spacer()
                                    }
                                )
                            
                        }
                        HStack {
                            Text("\(workout.title)")
                                .font(.title)
                            Spacer()
                        }
                        .padding(.horizontal,20)
                        .padding(.top,20)
                        VStack {
                            if (getDistinctPrimaryMuscles().isEmpty || getDistinctSecondaryMuscles().isEmpty) {
                                ProgressView("Loading Muscles...")
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                HStack{
                                    Spacer()
                                    ScrollView(.vertical,showsIndicators: false) {
                                        Text("Primary")
                                            .fontWeight(.medium)
                                            .padding(.bottom,10)
                                            .padding(.top,30)
                                        ForEach(getDistinctPrimaryMuscles(),id: \.self) { muscle in
                                            Text("\(muscle)")
                                                .font(.caption)
                                                .padding(.vertical,5)
                                                .padding(.horizontal,10)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(10)
                                                .foregroundColor(.black)
                                        }
                                        Text("Secondary")
                                            .fontWeight(.medium)
                                            .padding(.vertical,10)
                                        ForEach(getDistinctSecondaryMuscles(),id: \.self) { muscle in
                                            Text("\(muscle)")
                                                .font(.caption)
                                                .padding(.vertical,5)
                                                .padding(.horizontal,10)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(10)
                                                .foregroundColor(.black)
                                        }
                                        
                                        
                                    }
                                    .frame(width: 110, height:270)
                                    .padding(.bottom,10)
                                    //                                    .padding(.horizontal,20)
                                    ZStack{
                                        ForEach(getDistinctPrimaryMuscles(),id: \.self) { muscle in
                                            Image("\(workoutViewModel.imageName(for: muscle))")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 230, height: 230)
                                            Image("\(workoutViewModel.imageName(for: muscle))")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 230, height: 230)
                                        }
                                        ForEach(getDistinctSecondaryMuscles(),id: \.self){ muscle in
                                            Image("\(workoutViewModel.imageName(for: muscle))")
                                                .resizable()
                                                .scaledToFit()
                                            .frame(width: 230, height: 230)}
                                    }
                                }
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(radius: 5)
                                }
                            }}
                        .padding(.horizontal,20)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                            .frame(height: 150)
                            .padding(.horizontal,20)
                            .overlay(
                                HStack(){
                                    VStack{
                                        SummaryStatView(title: "TVL", value: String(format:"💪%.f kg",workout.totalWeight))
                                            .padding(.trailing,30)
                                        SummaryStatView(title:"Duration", value: "🕙\(formattedDuration) ")
                                            .padding(.trailing,30)
                                        
                                    }
                                    .padding(.leading,40)
                                    
                                    VStack{
                                        SummaryStatView(title: "Calories", value: String("🔥\(workout.totalCalories) "))
                                        
                                        SummaryStatView(title:"Exercises", value: "🏋️‍♀️\(exercises.count)")
                                    }
                                    .padding(.trailing,40)
                                    
                                }
                                
                            )
                        
                        HStack {
                            Text("Workout log")
                                .font(.title2)
                            Spacer()
                            Button(action: {
                                isActive = false
                                var tuples: [Exercise] = []
                                for exercise in exercises {
                                    let newExercise: Exercise = Exercise(exercise: exercise.1, sets: exercise.0.sets)
                                    tuples.append(newExercise)
                                }
                                workoutViewModel.tuples = tuples
                                isEditingMode = true
                            }) {
                                HStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "pencil")
                                                .foregroundColor(.black)
                                                .frame(width: 20, height: 20))
                                        .padding(.leading,10)
                                }
                            }
                            
                        }
                        .padding(.horizontal,20)
                        .padding(.top,20)
                        .padding(.bottom,-5)
                        
                        List{
                            ForEach(exercises, id: \.0.id) { exercise in
                                ExerciseItem(exercise: exercise)
                            }
                            .padding(.top,-15)
                        }
                        .listStyle(.plain)
                        .frame(width: g.size.width, height: g.size.height, alignment: .center)
                        .foregroundStyle(.black)
                    }
                    if isEditWorkoutDetailsPresented {
                        Color.black.opacity(0.8)
                            .ignoresSafeArea()
                        VStack {
                            Text("Edit Workout Details")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.top,30)
                            HStack {
                                Text("Title")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading,20)
                                    .padding(.top,20)
                                Spacer()
                            }
                            TextField("Title", text: $workoutTitle)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                            HStack {
                                Text("Date")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading,20)
                                    .padding(.top,30)
                                Spacer()
                            }
                            DatePicker("", selection: $workoutDate, in: ...Date(), displayedComponents: .date)
                                           .datePickerStyle(WheelDatePickerStyle())
                                .padding(.horizontal)
                            Button("Update Workout"){
                                
                                
                                Task{
                                    await workoutViewModel.updateWorkoutDetails(workoutId: workout.id, workoutTitle: workoutTitle, workoutDate: workoutDate)
                                }
                                isEditWorkoutDetailsPresented.toggle()
                                isUpdatedWorkoutAlertPresented = true
                            }
                            Button("Cancel") {
                                
                                isEditWorkoutDetailsPresented.toggle()
                            }
                            .padding(.top,5)
                            .padding(.bottom,20)
                            .foregroundColor(.red)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding()
                    }
                    
                    
                }
                .navigationTitle("Workout Summary")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isActive = false
                        }) {
                            HStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "arrow.backward")
                                            .foregroundColor(.black)
                                            .frame(width: 20, height: 20))
                                    .padding(.leading,10)
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Menu {
                            Button(){
                                isEditWorkoutDetailsPresented = true
                                
                            } label: {
                                Label("Edit Workout Details", systemImage: "pencil")
                            }
                            Button(role: .destructive){
                                isDeleteAlertPresented = true
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            
                        } label: {
                            HStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.black)
                                            .frame(width: 20, height: 20)
                                    )
                                    .padding(.trailing,10)
                            }
                        }
                        
                    }
                }
            }
            .onAppear(){
                Task {
                    do {
                        exercises = try await workoutViewModel.getWorkoutExercises(workout: workout)

                        
                    } catch {
                        print("Error fetching exercises for workout:", error)
                    }
                }
                workoutTitle = workout.title
                workoutDate = workout.date
            }
            .fullScreenCover(isPresented: $isEditingMode){
                
                NavigationView{
                    EditWorkoutView(viewModel: workoutViewModel,workout: $workout, viewIsActive: $isEditingMode)
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
                        isActive = false},
                    secondaryButton: .cancel()
                )
            }
            .alert(isPresented: $isUpdatedWorkoutAlertPresented)
            {
                Alert(
                    title: Text("Workout Updated"),
                    message: Text("The workout has been updated successfully"),
                    dismissButton: .default(Text("OK"))
                )
            }
           
        }
    }
}

extension WorkoutDetails {
    private func formatDate(date: Date) -> String {
        print(date)
        if Calendar.current.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return "Today at " + formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy 'at' HH:mm"
            return formatter.string(from: date)        }
    }
    
    func getDistinctPrimaryMuscles() -> [String]{
        var muscles: [String] = []
        for exercise in exercises {
            for muscle in exercise.1.primaryMuscle {
                if !muscles.contains(muscle) {
                    muscles.append(muscle)
                }
            }
        }
        return muscles
    }
    func getDistinctSecondaryMuscles() -> [String]{
        let primaryMuscles: [String] = getDistinctPrimaryMuscles()
        var muscles: [String] = []
        for exercise in exercises {
            if let secondaryMuscle =
                exercise.1.secondaryMuscle {
                for muscle in secondaryMuscle {
                    if !muscles.contains(muscle) && !primaryMuscles.contains(muscle){
                        muscles.append(muscle)
                    }
                }
            }
        }
        return muscles
    }
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
}

struct SummaryStatView: View {
    var title: String
    var value: String
    var body: some View {
        VStack {
            Text(value)
                .font(.title3)
                .padding(.top,10)
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    WorkoutDetails(isActive: .constant(true), workout: DBWorkout())
        .environmentObject(ProfileViewModel())
        .environmentObject(WorkoutViewModel())
    
}
