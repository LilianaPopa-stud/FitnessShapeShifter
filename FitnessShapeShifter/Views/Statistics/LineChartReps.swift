//
//  LineChartReps.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 17.06.2024.
//

import SwiftUI
import Charts
@MainActor
class LineChartRepsViewModel: ObservableObject {
    @Published var dataReps: [Item] = []
    @Published var selectedInterval: DateInterval = DateInterval()
    @Published var selectedIntervalType: DateIntervalType = .week
    
    private let userManager = UserManager.shared
    
    func fetchReps() async throws {
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid
        
        let allWorkouts: [DBWorkout]
        
        switch selectedIntervalType {
        case .allTime:
            allWorkouts = try await userManager.fetchWorkoutsDescendingByDate(userId: userId)
        default:
            allWorkouts = try await userManager.fetchWorkoutsInDateRange(userId: userId, startDate: selectedInterval.start, endDate: selectedInterval.end)
        }
        
        var totalRepsByInterval: [Date: Int] = [:]
        let calendar = Calendar.current
        
        switch selectedIntervalType {
        case .allTime:
            guard let firstWorkoutDate = allWorkouts.last?.date,
                  let lastWorkoutDate = allWorkouts.first?.date else {
                return
            }
            
            var currentDate = firstWorkoutDate
            while currentDate <= lastWorkoutDate {
                totalRepsByInterval[currentDate.startOfMonth()] = 0
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
                totalRepsByInterval[intervalStartDate] = (totalRepsByInterval[intervalStartDate] ?? 0) + workout.totalReps
            }
            
        case .year:
            guard let firstWorkoutDate = allWorkouts.last?.date,
                  let lastWorkoutDate = allWorkouts.first?.date else {
                return
            }
            
            var currentDate = firstWorkoutDate
            while currentDate <= lastWorkoutDate {
                totalRepsByInterval[currentDate.startOfMonth()] = 0
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
                totalRepsByInterval[intervalStartDate] = (totalRepsByInterval[intervalStartDate] ?? 0) + workout.totalReps
            }
            
        case .month:
            var startOfMonth = selectedInterval.start.startOfMonth()
            let endOfMonth = selectedInterval.end.endOfMonth()
            
            while startOfMonth <= endOfMonth {
                totalRepsByInterval[startOfMonth] = 0
                startOfMonth = calendar.date(byAdding: .day, value: 1, to: startOfMonth)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: workout.date))!
                totalRepsByInterval[intervalStartDate] = (totalRepsByInterval[intervalStartDate] ?? 0) + workout.totalReps
            }
            
        case .week:
            let startOfWeek = selectedInterval.start.startOfWeek()
            let endOfWeek = selectedInterval.end.endOfWeek()
            
            var currentDate = startOfWeek
            while currentDate <= endOfWeek {
                totalRepsByInterval[currentDate] = 0
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: workout.date))!
                totalRepsByInterval[intervalStartDate] = (totalRepsByInterval[intervalStartDate] ?? 0) + workout.totalReps
            }
        }
        
        let sortedIntervals = totalRepsByInterval.keys.sorted()
        dataReps = sortedIntervals.map { date in
            Item(date: date, value: totalRepsByInterval[date]!, type: .basic)
        }
        dataReps.sort(by: { $0.date < $1.date })
    }
}


struct Item: Identifiable, Equatable{
    var id = UUID()
    var date: Date
    var value: Int
    
    var type: LineChartType
}

struct LineChartReps: View {
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor2, Color.accentColor2.opacity(0.1)])
    }
    
    @Binding var selectedIntervalType: DateIntervalType
    @StateObject var viewModel = LineChartRepsViewModel()
    @Binding var selectedDateRange: DateInterval
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.dataReps, id: \.id) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Repetitions", item.value)
                    )
                    .foregroundStyle(item.type.color)
                    .interpolationMethod(.linear)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(item.type.color)
                            .frame(width: 6, height: 6)
                    }
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("Repetitions", item.value)
                    )
                    .interpolationMethod(.linear)
                    .foregroundStyle(areaBackground)
                }
            }
            .padding(5)
            .background(Color(.systemGray6))
            .chartXAxis {
                AxisMarks(values: getAxisMarkValues()) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: getAxisValueLabelFormat(), centered: false)
                }
            }
        }
        .frame(height: 230)
        .onAppear {
            viewModel.selectedIntervalType = selectedIntervalType
            viewModel.selectedInterval = selectedDateRange
            Task {
                do {
                    try await viewModel.fetchReps()
                } catch {
                    print("Error fetching Reps")
                }
            }
        }
        .onChange(of: selectedIntervalType) { newIntervalType in
            viewModel.selectedIntervalType = newIntervalType
            Task {
                do {
                    try await viewModel.fetchReps()
                } catch {
                    print("Error fetching Reps")
                }
            }
        }
        .onChange(of: selectedDateRange) { _ in
            Task {
                do {
                    try await viewModel.fetchReps()
                } catch {
                    print("Error fetching Reps")
                }
            }
        }
    }
    
    private func getAxisMarkValues() -> [Date] {
        switch selectedIntervalType {
        case .week:
            let calendar = Calendar.current
            var currentDate = selectedDateRange.start
            var axisDates: [Date] = []
            
            while currentDate <= selectedDateRange.end {
                axisDates.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            return axisDates
            
        case .month:
            let calendar = Calendar.current
            var startOfMonthComponents = calendar.dateComponents([.year, .month], from: selectedDateRange.start)
            startOfMonthComponents.day = 1
            let startOfMonth = calendar.date(from: startOfMonthComponents)!
            
            var axisDates: [Date] = []
            var currentDate = startOfMonth
            while currentDate <= selectedDateRange.end {
                axisDates.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 5, to: currentDate)!
            }
            
            return axisDates
            
        case .year, .allTime:
            return viewModel.dataReps.map { $0.date }
        }
    }
    
    private func getAxisValueLabelFormat() -> Date.FormatStyle {
        switch selectedIntervalType {
        case .week:
            return .dateTime.day()
        case .month:
            return .dateTime.day()
        case .year, .allTime:
            return .dateTime.month(.abbreviated)
        }
    }
}



#Preview {
    LineChartReps(selectedIntervalType: .constant(.allTime), selectedDateRange: .constant(DateInterval()))
}
