//
//  Stats.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 25.03.2024.
//

import SwiftUI

struct Stats: View {
    @StateObject var viewModel: StatsViewModel = StatsViewModel()
    
    @State private var isShowingSheet = false
    @State var nrOfWorkouts: Int = 50
    @State var TVL: Int = 30222
    @State var calories: Int = 30211
    @State var reps: Int = 888
    @State var sets: Int = 19
    @State var hours: Double = 10.3
    var body: some View {
        ZStack{
            AppBackground()
            NavigationStack {
                ScrollView {
                    VStack{
                        HStack
                        {
                            Text("Overall stats")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                            DatePicker("", selection: .constant(Date()))
                                .onTapGesture {
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
                        
                        Spacer()
                    }
                    
                }
                .navigationTitle("Statistics")
            }
            
        }
        .sheet(isPresented: $isShowingSheet) {
            PeriodSelectionSheet(dateInterval: $viewModel.selectedDateRange, isShowingSheet: self.$isShowingSheet)
        }
        .onAppear{
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
                HStack{
                    
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
}
