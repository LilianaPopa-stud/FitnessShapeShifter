//
//  PeriodSelectionSheet.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 25.04.2024.
//
import SwiftUI
import Foundation

enum DateIntervalType: String, CaseIterable {
    case allTime = "All Time"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct PeriodSelectionSheet: View {
    @Binding var selectedOption: String
    @Binding var allTimeStats: Bool
    @Binding var dateInterval: DateInterval
    @Binding var isShowingSheet: Bool
    @Binding var selectedIntervalType: DateIntervalType
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var dates: Set<DateComponents> = []
    var datesBinding: Binding<Set<DateComponents>> {
        Binding {
            print(dates)
            return dates
        } set: { newValue in
            let added = newValue.subtracting(dates)
            if let firstAdded = added.first, let date = calendar.date(from: firstAdded) {
                selectWeek(for: date)
            } else {
                dates = []
            }
        }
    }
    let backgroundColor: Color = .accentColor2
    let fontColor: Color = .white
    @Environment(\.calendar) var calendar
    
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                
                Text("Filter Period")
                    .font(.headline)
                    .padding(.top,20)
                Form{
                    Picker(selection: $selectedIntervalType, label: Text("Period")) {
                        ForEach(DateIntervalType.allCases, id: \.self) { intervalType in
                            Text(intervalType.rawValue).tag(intervalType)
                        }
                    }
                    .pickerStyle(.inline)
                    if selectedIntervalType == .week {
                        MultiDatePicker("", selection: datesBinding)
                            .frame(height: 300)
                        
                    } else if selectedIntervalType == .month {
                        HStack {
                            Picker("Month", selection: $selectedMonth) {
                                ForEach(1...12, id: \.self) { month in
                                    Text(DateFormatter().monthSymbols[month - 1]).tag(month)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            Picker("Year", selection: $selectedYear) {
                                ForEach(2000...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                                    Text(String(year)).tag(year)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                        
                    } else if selectedIntervalType == .year {
                        Picker("Year", selection: $selectedYear) {
                            ForEach(2000...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                                Text(String(year)).tag(year)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    
                }
                .scrollContentBackground(.hidden)
                
                
                Button(action: {
                    if selectedIntervalType != .allTime {
                        allTimeStats = false
                    }
                    if selectedIntervalType == .week {
                        let (firstDay, lastDay) = getWeekBounds(for: dates.first)
                        guard let firstDay = firstDay, let lastDay = lastDay else { return }
                        dateInterval = DateInterval(start: firstDay, end: lastDay)
                        var dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        let lastDayString = dateFormatter.string(from: lastDay)
                        dateFormatter.dateFormat = "dd"
                        let firstDayString = dateFormatter.string(from: firstDay)
                        selectedOption = "\(firstDayString)-\(lastDayString)"
                        
                        
                    } else if selectedIntervalType == .month {
                        let firstDay = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))
                        let lastDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDay!)
                        guard let firstDay = firstDay, let lastDay = lastDay else { return }
                        dateInterval = DateInterval(start: firstDay, end: lastDay)
                        var dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM yyyy"
                        let lastDayString = dateFormatter.string(from: lastDay)
                        selectedOption = lastDayString
                        
                    } else if selectedIntervalType == .year {
                        print(selectedYear)
                        let firstDay = calendar.date(from: DateComponents(year: selectedYear, month: 1, day: 1))
                        let lastDay = calendar.date(from: DateComponents(year: selectedYear, month: 12, day: 31))
                        dateInterval = DateInterval(start: firstDay ?? Date(), end: lastDay ?? Date())
                        selectedOption = String(selectedYear)
                        
                    }   else if selectedIntervalType == .allTime {
                        allTimeStats = true
                        selectedOption = "All time"
                    }
                    isShowingSheet = false
                }, label: {
                    VStack {
                        Text("Apply")
                    }
                    .font(.headline)
                    .font(Font.custom("RobotoCondensed-Bold", size: 18))
                    .foregroundColor(fontColor)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(backgroundColor)
                            .shadow(color: .shadow, radius: 4, x: 1, y: 3))
                })
                .padding(.horizontal,20)
                Spacer()
            }
        }
    }
    private func selectWeek(for date: Date) {
        dates = []
        let calendar = Calendar.current
        let weekBoundary = calendar.weekBoundary(for: date)
        for dayOffset in 0..<7 {
            if let dateOfDay = calendar.date(byAdding: .day, value: dayOffset, to: weekBoundary.startOfWeek) {
                let components = calendar.dateComponents([.year, .month, .day], from: dateOfDay)
                dates.insert(components)
            }
        }
    }
    private func getWeekBounds() -> (firstDay: Date?, lastDay: Date?) {
        guard let firstDateComponent = dates.min(by: { $0.date! < $1.date! }),
              let lastDateComponent = dates.max(by: { $0.date! < $1.date! }) else {
            return (nil, nil)
        }
        
        let firstDay = calendar.date(from: firstDateComponent)
        let lastDay = calendar.date(from: lastDateComponent)
        
        return (firstDay, lastDay)
    }
    private func getWeekBounds(for dateComponent: DateComponents?) -> (firstDay: Date?, lastDay: Date?) {
        guard let dateComponent = dateComponent,
              let date = calendar.date(from: dateComponent) else {
            return (nil, nil)
        }
        
        var startOfWeek: Date = Date()
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: date)
        
        let endOfWeek = startOfWeek.addingTimeInterval(interval - 1)
        
        return (startOfWeek, endOfWeek)
    }
    
    
}
extension Calendar {
    func weekBoundary(for date: Date) -> (startOfWeek: Date, endOfWeek: Date) {
        var startOfWeek: Date = Date()
        var interval: TimeInterval = 0
        _ = dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: date)
        let endOfWeek = startOfWeek.addingTimeInterval(interval - 1)
        return (startOfWeek, endOfWeek)
    }
}

#Preview {
    PeriodSelectionSheet(selectedOption: .constant("All time"), allTimeStats: .constant(false), dateInterval: .constant(DateInterval()), isShowingSheet: .constant(true), selectedIntervalType: .constant(.allTime))
}
