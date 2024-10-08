//
//  LineChartTVL.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 26.04.2024.
//

import SwiftUI
import Charts
import Foundation


@MainActor
class LineChartViewModel: ObservableObject {
    
    @Published var dataTVL: [TVL] = []
    @Published var selectedInterval: DateInterval = DateInterval()
    @Published var selectedIntervalType: DateIntervalType = .week
    
    private let userManager = UserManager.shared
    func fetchTVL() async throws {
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid
        
        let allWorkouts: [DBWorkout]
        
        switch selectedIntervalType {
        case .allTime:
            allWorkouts = try await userManager.fetchWorkoutsDescendingByDate(userId: userId)
        default:
            allWorkouts = try await userManager.fetchWorkoutsInDateRange(userId: userId, startDate: selectedInterval.start, endDate: selectedInterval.end)
        }
        print(selectedInterval.start)
        print(selectedInterval.end)
        
        var totalWeightByInterval: [Date: Double] = [:]
        let calendar = Calendar.current
        
        switch selectedIntervalType {
        case .allTime:
            guard let firstWorkoutDate = allWorkouts.last?.date,
                  let lastWorkoutDate = allWorkouts.first?.date else {
                return
            }
            
            var currentDate = firstWorkoutDate
            while currentDate <= lastWorkoutDate {
                totalWeightByInterval[currentDate.startOfMonth()] = 0
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
                totalWeightByInterval[intervalStartDate] = (totalWeightByInterval[intervalStartDate] ?? 0) + workout.totalWeight
            }
            
        case .year:
            guard let firstWorkoutDate = allWorkouts.last?.date,
                  let lastWorkoutDate = allWorkouts.first?.date else {
                return
            }
            
            var currentDate = firstWorkoutDate
            while currentDate <= lastWorkoutDate {
                totalWeightByInterval[currentDate.startOfMonth()] = 0
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
                totalWeightByInterval[intervalStartDate] = (totalWeightByInterval[intervalStartDate] ?? 0) + workout.totalWeight
            }
            
        case .month:
            var startOfMonth = selectedInterval.start.startOfMonth()
            let endOfMonth = selectedInterval.end.endOfMonth()
            
            while startOfMonth <= endOfMonth {
                totalWeightByInterval[startOfMonth] = 0
                startOfMonth = calendar.date(byAdding: .day, value: 1, to: startOfMonth)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: workout.date))!
                totalWeightByInterval[intervalStartDate] = (totalWeightByInterval[intervalStartDate] ?? 0) + workout.totalWeight
            }
            
        case .week:
            let startOfWeek = selectedInterval.start.startOfWeek()
            let endOfWeek = selectedInterval.end.endOfWeek()
            
            var currentDate = startOfWeek
            while currentDate <= endOfWeek {
                totalWeightByInterval[currentDate] = 0
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            allWorkouts.forEach { workout in
                let intervalStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: workout.date))!
                totalWeightByInterval[intervalStartDate] = (totalWeightByInterval[intervalStartDate] ?? 0) + workout.totalWeight
            }
        }
        
        let sortedIntervals = totalWeightByInterval.keys.sorted()
        dataTVL = sortedIntervals.map { date in
            TVL(date: date, value: totalWeightByInterval[date]!, type: .basic)
        }
        print(dataTVL)
        
    }
}
extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    func endOfMonth() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return calendar.date(byAdding: components, to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    func endOfWeek() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 7
        return calendar.date(byAdding: components, to: self.startOfWeek())!
    }
}

struct TVL: Identifiable, Equatable{
    var id = UUID()
    var date: Date
    var value: Double
    
    var type: LineChartType
}

enum LineChartType: String, CaseIterable, Plottable {
    case basic = "basic"
    
    var color: Color {
        switch self {
        case .basic: return .accentColor2
        }
    }
}

struct LineChartTVL: View {
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor2, Color.accentColor2.opacity(0.1)])
    }
    @Binding var selectedIntervalType: DateIntervalType
    @StateObject var viewModel = LineChartViewModel()
    @Binding var selectedDateRange: DateInterval
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.dataTVL, id: \.id) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Value", item.value)
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
                        y: .value("Value", item.value)
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
                    try await viewModel.fetchTVL()
                } catch {
                    print("Error fetching TVL")
                }
            }
        }
        .onChange(of: selectedIntervalType) { newIntervalType in
            viewModel.selectedIntervalType = newIntervalType
            Task {
                do {
                    try await viewModel.fetchTVL()
                } catch {
                    print("Error fetching TVL")
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
            return viewModel.dataTVL.map { $0.date }
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
    LineChartTVL(selectedIntervalType: .constant(.allTime), selectedDateRange: .constant(DateInterval()))
    
    
}
