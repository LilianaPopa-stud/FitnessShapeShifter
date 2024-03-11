//
//  OnboardingView.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 08.02.2024.
//

import SwiftUI

struct GenderView: View {
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @Binding var showOnboarding: Bool
    @State private var selectedGender = "Female"
    @State var buttonTitle: String = "Next"
    let genders = ["Male", "Female","Other"]
    @State private var selectedAgeIndex = 0
    @State private var isNextViewActive = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                AppBackground()
                VStack {
                    Text("Let's set up your profile")
                        .font(Font.custom("Bodoni 72", size: 30))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 75)
                    
                    Image(.squat)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 250, maxHeight: 250, alignment: .center)
                    
                    Text("Choose your gender")
                        .font(Font.custom("Bodoni 72", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    Text("If you choose to provide this information for us, we may use it to personalize your workouts")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)
                    Picker("Gender", selection: $viewModel.gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background()
                    .padding(.bottom, 10)
                    Spacer()
                    NextButton(buttonTitle: "Next", isLast: false, isActive: $isNextViewActive, destination: WeightAndHeight(viewModel: viewModel, showSignInView: $showSignInView, showOnboarding: $showOnboarding))
                }
                .padding(30)
            }
        }
    }
}

#Preview {
    GenderView(showSignInView: .constant(false), showOnboarding: .constant(false))
}
