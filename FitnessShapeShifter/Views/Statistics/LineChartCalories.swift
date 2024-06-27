//
//  LineChartCalories.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 17.06.2024.
//

import SwiftUI
import Charts

@MainActor
class LineChartCaloriesViewModel: ObservableObject {
    @Published var dataCalories: [Item] = []
    @Published var selectedInterval: DateInterval = DateInterval()
    @Published var selectedIntervalType: DateIntervalType = .week
    
    private let userManager = UserManager.shared
    
    func fetchCalories() async throws {
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid
        
        let allWorkouts: [DBWorkout]
        
        switch selectedIntervalType {
        case .allTime:
            allWorkouts = try await userManager.fetchWorkoutsDescendingByDate(userId: userId)
        default:
            allWorkouts = try await userManager.fetchWorkoutsInDateRange(userId: userId, startDate: selectedInterval.start, endDate: selectedInterval.end)
        }
        
        var totalCaloriesByInterval: [Date: Int] = [:]
        let calendar = Calendar.current
        
        switch selectedIntervalType {
        case .allTime:
            guard let firstWorkoutDate = allWorkouts.last?.date,
                  let lastWorkoutDate = allWorkouts.first?.date else {
                return
            }
            
            var currentDate = firstWorkoutDate
            while currentDate <= lastWorkoutDate {
                totalCaloriesByInterval[currentDate.startOfMonth()] = 0
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
                totalCaloriesByInterval[intervalStartDate] = (totalCaloriesByInterval[intervalStartDate] ?? 0) + workout.totalCalories
            }
            
        case .year:
            guard let firstWorkoutDate = allWorkouts.last?.date,
                  let lastWorkoutDate = allWorkouts.first?.date else {
                return
            }
            
            var currentDate = firstWorkoutDate
            while currentDate <= lastWorkoutDate {
                totalCaloriesByInterval[currentDate.startOfMonth()] = 0
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
                totalCaloriesByInterval[intervalStartDate] = (totalCaloriesByInterval[intervalStartDate] ?? 0) + workout.totalCalories
            }
            
        case .month:
            var startOfMonth = selectedInterval.start.startOfMonth()
            let endOfMonth = selectedInterval.end.endOfMonth()
            
            while startOfMonth <= endOfMonth {
                totalCaloriesByInterval[startOfMonth] = 0
                startOfMonth = calendar.date(byAdding: .day, value: 1, to: startOfMonth)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: workout.date))!
                totalCaloriesByInterval[intervalStartDate] = (totalCaloriesByInterval[intervalStartDate] ?? 0) + workout.totalCalories
            }
            
        case .week:
            let startOfWeek = selectedInterval.start.startOfWeek()
            let endOfWeek = selectedInterval.end.endOfWeek()
            
            var currentDate = startOfWeek
            while currentDate <= endOfWeek {
                totalCaloriesByInterval[currentDate] = 0
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: workout.date))!
                totalCaloriesByInterval[intervalStartDate] = (totalCaloriesByInterval[intervalStartDate] ?? 0) + workout.totalCalories
            }
        }
        
        let sortedIntervals = totalCaloriesByInterval.keys.sorted()
        dataCalories = sortedIntervals.map { date in
            Item(date: date, value: totalCaloriesByInterval[date]!, type: .basic)
        }
        dataCalories.sort(by: { $0.date < $1.date })
    }
}

struct LineChartCalories: View {
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor2, Color.accentColor2.opacity(0.1)])
    }
    
    @Binding var selectedIntervalType: DateIntervalType
    @StateObject var viewModel = LineChartCaloriesViewModel()
    @Binding var selectedDateRange: DateInterval
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.dataCalories, id: \.id) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Calories", item.value)
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
                        y: .value("Calories", item.value)
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
                    try await viewModel.fetchCalories()
                } catch {
                    print("Error fetching Calories")
                }
            }
        }
        .onChange(of: selectedIntervalType) { newIntervalType in
            viewModel.selectedIntervalType = newIntervalType
            Task {
                do {
                    try await viewModel.fetchCalories()
                } catch {
                    print("Error fetching Calories")
                }
            }
        }
        .onChange(of: selectedDateRange) { _ in
            Task {
                do {
                    try await viewModel.fetchCalories()
                } catch {
                    print("Error fetching Calories")
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
            return viewModel.dataCalories.map { $0.date }
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
    LineChartCalories(selectedIntervalType: .constant(.allTime), selectedDateRange: .constant(DateInterval()))
}

