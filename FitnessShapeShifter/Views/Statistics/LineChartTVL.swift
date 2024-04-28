//
//  LineChartTVL.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 26.04.2024.
//

import SwiftUI
import Charts
import Foundation

class LineChartViewModel: ObservableObject {
    @Published var data: [Date: Double] = [:]
    @Published var dataTVL: [TVL] = []
    @Published var selectedDateRange: DateInterval = DateInterval()
    @Published var isAllTime: Bool = true
    @Published var months: [Date] = []
    
    private let userManager = UserManager.shared
    func fetchTVL() async throws {
        if !isAllTime {
            // Fetch workouts in the selected date range
        } else {
            // Fetch all workouts
        }
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid
        // Calculate total weight lifted for each month
        let allWorkouts = isAllTime ? try await userManager.fetchWorkoutsDescendingByDate(userId: userId) :
        try await userManager.fetchWorkoutsInDateRange(userId: userId, startDate: selectedDateRange.start, endDate: selectedDateRange.end)
        
        
        guard let earliestDate = allWorkouts.map({ $0.date }).min() else {
            return
        }
        
        
        // Calculate the start date (one month before the earliest workout date)
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: earliestDate)!
        let endDate = Date()
        
        var totalWeightByMonth: [Date: Double] = [:]
        allWorkouts.forEach { workout in
            let lastDayOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: workout.date)!
            totalWeightByMonth[lastDayOfMonth] = (totalWeightByMonth[lastDayOfMonth] ?? 0) + workout.totalWeight
        }

       
        
        
        var currentDate = startDate
        while currentDate <= endDate {
            if totalWeightByMonth[currentDate] == nil {
                
                totalWeightByMonth[currentDate] = 0
            }
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        
        dataTVL = totalWeightByMonth.map { TVL(date: $0.key, value: $0.value, type: .basic) }
        dataTVL.sort(by: { $0.date < $1.date })
        
        
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
    @StateObject var viewModel = LineChartViewModel()
    var body: some View {
        VStack{
            Chart {
                ForEach(viewModel.dataTVL, id: \.id) { item in
                    LineMark(
                        x: .value("Weekday", item.date),
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
                        x: .value("Weekday", item.date),
                        y: .value("Value", item.value)
                         )
                         .interpolationMethod(.linear)
                         .foregroundStyle(areaBackground)
                    
                }
            }
            .padding(5)
            .background(Color(.systemGray6))
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 2)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                  }
                }
        }
        .frame(height: 330)
        .onAppear{
            Task{
                do{
                    try await viewModel.fetchTVL()
                   for item in viewModel.dataTVL{
                   }
                    
                }
                catch{
                    print("Error fetching TVL")
                }
                
            }
        }
        
    }
    
}



#Preview {
    LineChartTVL()
    
}
