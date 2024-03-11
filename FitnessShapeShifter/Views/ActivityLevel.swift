//
//  ActivityLevel.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 10.02.2024.
//

import SwiftUI

struct ActivityLevel: View {
    @StateObject var viewModel: ProfileViewModel
    @Binding var showSignInView: Bool
    @Binding var showOnboarding: Bool
    @State private var isSheetShowing = false
    @State private var isNextViewActive = false
    @State private var selectedActivityLevelIndex = 2
    let activityLevels = [
        "Sedentary",
        "Lightly Active",
        "Moderately Active",
        "Very Active",
        "Extra Active"
    ]
    let activityLevelsDescription: [String: String] = [
        "Sedentary": "Little to no exercise or desk job",
        "Lightly Active": "Light exercise  1-3 days a week",
        "Moderately Active": "Moderate exercise  3-5 days a week",
        "Very Active": "Hard exercise or sports 6-7 days a week",
        "Extra Active": "Very hard exercise, physical job, training twice a day"
    ]
    @State var popoverSize = CGSize(width: 300, height: 300)
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                Text("Let's set up your profile")
                    .font(Font.custom("Bodoni 72", size: 30, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                Image(.squat)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 250, maxHeight: 250, alignment: .center)
                Text("Select your activity level")
                    .font(Font.custom("Bodoni 72", size: 25))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)
                Button(action: { isSheetShowing.toggle()} ){
                    Image(systemName: "info.circle")
                }
                .sheet(isPresented: $isSheetShowing) {
                    ActivityLevelsSheet(description: activityLevelsDescription)
                        .presentationDetents([.fraction(0.6)])
                }
                Picker(selection: $selectedActivityLevelIndex, label: Text("Activity Level")) {
                    ForEach(0..<5) { index in
                        Text(activityLevels[index]).tag(index)
                    }
                }
                
                .pickerStyle(WheelPickerStyle())
                
                FinishOnboardingButton(viewModel: viewModel, showSignInView: $showSignInView, showOnboarding: $showOnboarding, activityLevel: activityLevels[selectedActivityLevelIndex])
                    .onTapGesture {
                        viewModel.activityLevel = activityLevels[selectedActivityLevelIndex]
                    }
                Spacer()
            }
            .padding(30)
        }
    }
}

struct ActivityLevelsSheet: View {
    let description: [String: String]
    var body: some View {
        VStack {
            Text("Activity Levels Description")
                .font(.footnote)
                .padding()
            Divider()
            VStack(alignment: .leading) {
                ForEach(description.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack(alignment: .top) {
                        Text("\(key): ")
                            .frame(width: 150)
                            .fontWeight(.medium)
                        Text("\(value)")
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ActivityLevel(viewModel: ProfileViewModel(), showSignInView: .constant(false), showOnboarding: .constant(false))
}
