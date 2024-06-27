//
//  FinishOnboardingButton.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 11.03.2024.
//

import SwiftUI

struct FinishOnboardingButton: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showSignInView: Bool
    @Binding var showOnboarding: Bool
    var activityLevel: String
    var body: some View {
        Button(action: {
            viewModel.activityLevel = activityLevel
            Task{
                do{
                    try await viewModel.loadCurrentUser()
                    try await viewModel.saveUserProfile()
                    showOnboarding = false
                    showSignInView = false
                }
                catch{
                    print("Error signing up: \(error.localizedDescription)")
                    
                }
            }
        }) {
            VStack {
                HStack {
                    Spacer()
                    Text("Finish")  
                    Image(systemName: "checkmark")
                }
            }
            .font(Font.custom("RobotoCondensed-Bold", size: 20))
            .padding(.trailing, 10)}
    }
}


#Preview {
    FinishOnboardingButton(viewModel: ProfileViewModel(), showSignInView: .constant(false), showOnboarding: .constant(false), activityLevel: "Sedentary")
}
