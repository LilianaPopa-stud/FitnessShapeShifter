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
    @Published var data: [Date: Double] = [:]
    @Published var dataTVL: [TVL] = []
    @Published var selectedDateRange: DateInterval = DateInterval()
    @Published var isAllTime: Bool = true
    

    
    private let userManager = UserManager.shared
    func fetchTVL() async throws {
      
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        let userId = authData.uid
        // Calculate total weight lifted for each month
        let allWorkouts = isAllTime ? try await userManager.fetchWorkoutsDescendingByDate(userId: userId) :
        try await userManager.fetchWorkoutsInDateRange(userId: userId, startDate: selectedDateRange.start, endDate: selectedDateRange.end)
        
        
        guard allWorkouts.map({ $0.date }).min() != nil else {
            return
        }
        
       
        var totalWeightByMonth: [Date: Double] = [:]
        allWorkouts.forEach { workout in
            let calendar = Calendar.current
            let endOfLastMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: workout.date))!
            let startOfMonth = calendar.date(byAdding: DateComponents(month: 0, day: 1), to: endOfLastMonth)!
            
            totalWeightByMonth[startOfMonth] = (totalWeightByMonth[startOfMonth] ?? 0) + workout.totalWeight
        }

        var currentMonth = totalWeightByMonth.keys.min()!
        // current month - 1
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
        let endDate = totalWeightByMonth.keys.max()!
        while currentMonth <= endDate {
            if totalWeightByMonth[currentMonth] == nil {
                
                totalWeightByMonth[currentMonth] = 0
            }
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
        }
        
        
        dataTVL = totalWeightByMonth.map { TVL(date: $0.key, value: $0.value, type: .basic) }
        dataTVL.sort(by: { $0.date < $1.date })
        print(dataTVL)
        
        
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
                        x: .value("Month", item.date),
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
                        x: .value("Month", item.date),
                        y: .value("Value", item.value)
                         )
                         .interpolationMethod(.linear)
                         .foregroundStyle(areaBackground)
                    
                }
            }
            .padding(5)
            .background(Color(.systemGray6))
            .chartXAxis {
                
                AxisMarks(values: .stride(by: .month, count: viewModel.dataTVL.count>10 ? 2 : 1)){ _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated), centered: false)
                  }
                }
          }
        .frame(height: 230)
        .onAppear{
            Task{
                do {
                    try await viewModel.fetchTVL()
                    
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
