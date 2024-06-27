//
//  Stats.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 25.03.2024.
//

import SwiftUI

struct Stats: View {
    @StateObject var viewModel: StatsViewModel = StatsViewModel()
    @State private var selectedOption: String = "All time"
    @State var selectedIntervalType = DateIntervalType.allTime
    @State private var isShowingSheet = false
    @State var nrOfWorkouts: Int = 50
    @State var TVL: Int = 30222
    @State var calories: Int = 30211
    @State var reps: Int = 888
    @State var sets: Int = 19
    @State var hours: Double = 10.3
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack{
            AppBackground()
            NavigationStack {
                ScrollView {
                    TabView(selection: $currentIndex.animation()){
                        VStack{
                            HStack
                            { Text("Overall stats")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(selectedOption)")
                                    .padding(.horizontal,15)
                                    .padding(.vertical,5)
                                //system gray 6
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture{
                                        self.isShowingSheet = true
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical,10)
                            
                            Group{
                                HStack {
                                    StatCellView(title: "🏋️Workouts",value: String(viewModel.nrOfWorkouts) )
                                    
                                    StatCellView(title: "💪TVL",value: String("\(viewModel.TVL) kg"))
                                        .padding(.leading,10)
                                }
                                .padding(.bottom,1)
                                HStack {
                                    StatCellView(title: "🔥Calories",value: String(viewModel.calories) )
                                    
                                    StatCellView(title: "🕙Hours",value: String(format: "%.2f",viewModel.hours/3600))
                                        .padding(.leading,10)
                                }
                                .padding(.bottom,1)
                                HStack {
                                    StatCellView(title: "🔁Sets",value: String(viewModel.sets) )
                                    
                                    StatCellView(title: "🔁Repetitions",value: String(viewModel.reps))
                                        .padding(.leading,10)
                                }
                                
                            }
                            .padding(.horizontal)
                        }
                        .tag(0)
                        .frame(height: 240)
                        
                        
                        VStack {
                            HStack
                            { Text("TVL: ")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(selectedOption)")
                                    .padding(.horizontal,15)
                                    .padding(.vertical,5)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture{
                                        self.isShowingSheet = true
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical,10)
                            LineChartTVL(selectedIntervalType: $selectedIntervalType, selectedDateRange: $viewModel.selectedDateRange)
                                .padding(.horizontal)
                                .environmentObject(StatsViewModel())
                            
                        }
                        .tag(1)
                        
                        VStack {
                            HStack
                            { Text("Reps: ")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(selectedOption)")
                                    .padding(.horizontal,15)
                                    .padding(.vertical,5)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture{
                                        self.isShowingSheet = true
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical,10)
                            LineChartReps(selectedIntervalType: $selectedIntervalType, selectedDateRange: $viewModel.selectedDateRange)
                                .padding(.horizontal)
                                .environmentObject(StatsViewModel())
                            
                        }
                        .tag(2)
                        VStack {
                            HStack
                            { Text("Calories: ")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(selectedOption)")
                                    .padding(.horizontal,15)
                                    .padding(.vertical,5)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture{
                                        self.isShowingSheet = true
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical,10)
                            LineChartCalories(selectedIntervalType: $selectedIntervalType, selectedDateRange: $viewModel.selectedDateRange)
                                .padding(.horizontal)
                                .environmentObject(StatsViewModel())
                            
                        }
                        .tag(3)
                        
                    }
                    .overlay(Fancy3DotsIndexView(numberOfPages: 3, currentIndex: currentIndex))
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 330)
                    .tabViewStyle(.page)
                    
                    MuscleChart()
                        .frame(height: 400)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        
                        VStack {
                            Text("Statistics")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            PeriodSelectionSheet(selectedOption: $selectedOption, allTimeStats: $viewModel.allTimeStats, dateInterval: $viewModel.selectedDateRange, isShowingSheet: self.$isShowingSheet, selectedIntervalType: $selectedIntervalType)
        }
        .onAppear{
            Task {
                try await viewModel.fetchStats()
            }
        }
        .onChange(of: viewModel.selectedDateRange){
            Task {
                try await viewModel.fetchStats()
            }
        }
        .onChange(of: viewModel.allTimeStats){
            Task {
                try await viewModel.fetchStats()
            }
        }
    }
}


struct StatCellView: View {
    
    var title: String
    var value: String
    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColor2)
                .frame(height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.blue.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            VStack(alignment: .leading){
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top,5)
                HStack {
                    Text(value)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.leading,10)
        }
        
        
    }
}


#Preview {
    Stats()
        .environmentObject(StatsViewModel())
}
