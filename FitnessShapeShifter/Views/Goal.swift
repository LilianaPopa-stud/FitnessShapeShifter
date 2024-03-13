//
//  Goal.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 10.02.2024.
//

import SwiftUI

struct Goal: View {
    @StateObject var viewModel: ProfileViewModel
    @Binding var showSignInView: Bool
    @Binding var showOnboarding: Bool
    @State private var selectedGoalIndex = 2
      let fitnessGoals = [
          "Weight Loss",
          "Muscle Gain",
          "Endurance",
          "Flexibility",
          "Stress Relief"
      ]
    @State private var isNextViewActive = false
        
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                Text("Let's set up your profile")
                    .font(Font.custom("Bodoni 72", size: 30, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .center)
                // .padding(.top,scaledPadding)
                    .padding(.top, 40)
        
                Image(.squat2)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 250, maxHeight: 250, alignment: .center)

                Text("What's your fitness goal?")
                    .font(Font.custom("Bodoni 72", size: 25))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Picker(selection: $selectedGoalIndex, label: Text("Fitness Goal")) {
                    ForEach(0..<5) { index in
                        Text(fitnessGoals[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.bottom, 45)
               
                NextButton(buttonTitle: "Next", isLast: false, isActive: $isNextViewActive, destination: ActivityLevel(viewModel: viewModel, showSignInView: $showSignInView,showOnboarding: $showOnboarding))
                    
                Spacer()
            }
            .onDisappear() {
                viewModel.goal = fitnessGoals[selectedGoalIndex]
            }
            .padding(30)
        }
    }
}

#Preview {
    Goal(viewModel: ProfileViewModel(), showSignInView: .constant(false), showOnboarding: .constant(false))
}
