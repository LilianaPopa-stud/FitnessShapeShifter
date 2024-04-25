//
//  PeriodSelectionSheet.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 25.04.2024.
//
import SwiftUI

enum DateIntervalType: String, CaseIterable {
    case allTime = "All Time"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct PeriodSelectionSheet: View {
    @Binding var dateInterval: DateInterval
    @Binding var isShowingSheet: Bool
    @State private var selectedIntervalType: DateIntervalType = .week
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
            } else { // this means a date is deselected, so deselect the whole week
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
                    
                    
                    // based on selection, display the corresponding date picker
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
                    if selectedIntervalType == .week {
                        // first date and last date of the week
                      
                        
                    } else if selectedIntervalType == .month {
                        // do something with the selected month
                    } else if selectedIntervalType == .year {
                        // do something with the selected year
                    }
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
    PeriodSelectionSheet(dateInterval: .constant(DateInterval()), isShowingSheet: .constant(true) )
}
