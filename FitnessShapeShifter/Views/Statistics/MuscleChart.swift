//
//  SectorChartExample.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 17.06.2024.
//

import SwiftUI
import Charts
struct Product: Identifiable {
    let id = UUID()
    let title: String
    let revenue: Double
}
@MainActor
class MuscleChartViewModel: ObservableObject {
    @Published var totalRepsByCategory: [String: Int] = [:]
    private let userManager = UserManager.shared
    func getRepsPerMuscleCategory() async throws {
        totalRepsByCategory = [:]
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid

        let allWorkouts = try await userManager.fetchWorkoutsDescendingByDate(userId: userId)
        for workout in allWorkouts {
        
                   for exercise in workout.exercises {
                       do {
                           let dbExercise = try await ExerciseManager.shared.getExercise(exerciseId: exercise.exerciseId)
                           for muscle in dbExercise.primaryMuscle {
                               let category = category(for: muscle)
                               let reps = exercise.sets.reduce(0) { $0 + $1.reps }
                               totalRepsByCategory[category] = (totalRepsByCategory[category] ?? 0) + reps
                           }
                       } catch {
                           print("Failed to fetch exercise: \(error)")
                       }
                   }
               }
               
        print(totalRepsByCategory)
     

    }
    func category(for muscle: String) -> String {
        switch muscle {
        case "Biceps", "Triceps","Forearms" :
            return "Arms"
        case "Chest", "Inner Chest", "Lower Chest", "Upper Chest":
            return "Chest"
        case "Lats", "Traps", "Lower Back" :
            return "Back"
        case "Abdominals", "Obliques":
            return "Core"
        case "Quadriceps", "Hamstrings", "Calves", "Glutes", "Adductors":
            return "Legs"
        case "Shoulders", "Front Shoulders":
            return "Shoulders"
        default:
            return "none"
        }
    }
    
}
struct MuscleChartItem: Identifiable {
    let id = UUID()
    let category: String
    let reps: Int
}

struct MuscleChart: View {
    @StateObject private var viewModel = MuscleChartViewModel()
    @State private var items: [MuscleChartItem] = []
  
    var body: some View {
            VStack {
                GroupBox("Reps Per Muscle Group") {
                    Chart(items) { item in
                        SectorMark(
                            angle: .value(
                                Text(verbatim: item.category),
                                item.reps
                            ),
                            innerRadius: .ratio(0.6),
                            angularInset: 8
                        )
                        .opacity(0.6)
                        .cornerRadius(5)
                        .foregroundStyle(by: .value("Category", item.category))
                        .annotation(position: .overlay) {
                            Text("\(item.reps)")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical,10)
                    .chartLegend(position: .bottom, alignment: .center)
                }
            }
            .padding()
            .onAppear(){
                Task {
                    do {
                        try await viewModel.getRepsPerMuscleCategory()
                        items = viewModel.totalRepsByCategory.map { MuscleChartItem(category: $0.key, reps: $0.value) }
                    } catch {
                        print("Failed to fetch reps per muscle group: \(error)")
                    }
                }
               
            }
        }
   
}
#Preview {
    MuscleChart()
}


