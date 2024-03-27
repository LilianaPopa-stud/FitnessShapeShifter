//
//  WorkoutsView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 27.03.2024.
//

import SwiftUI

struct WorkoutsView: View {
    var body: some View {
        ZStack{
            AppBackground()
            NavigationView {
                VStack {
                    // button "Add workout"
                    AddWorkoutButton()
                        .padding(30)
                    //list of workouts
                    Spacer()
                }
                .navigationTitle("Your Workouts 🏋️")
            }
        }
    }
}

#Preview {
    WorkoutsView()
}
