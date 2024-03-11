//
//  SignUpConfirmationButton.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 04.03.2024.
//

import SwiftUI

//struct SignUpConfirmationButton: View {
//    @ObservedObject var viewModel: RegisterViewModel
//    @Binding var errorMessages: String?
//    @Binding var showSignInView: Bool
//    var body: some View {
//        Button(action: {
//            Task{
//                do{
//                    try await viewModel.signUp()
//                        //showSignInView = false
//                }
//                catch{
//                    print("Error signing up: \(error.localizedDescription)")
//                    errorMessages = error.localizedDescription
//                }
//            }
//        }) {
//            Text("Sign up")
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.accentColor2)
//                .cornerRadius(50)
//        }
//    }
//}
struct SignUpConfirmationButton: View {
    @ObservedObject var viewModel: RegisterViewModel
    @Binding var errorMessages: String?
    @Binding var showSignInView: Bool
    @Binding var showOnboarding: Bool
    
    var body: some View {
        NavigationLink(destination: GenderView(showSignInView: $showSignInView, showOnboarding: $showOnboarding), label: {
            Button(action: {
                Task {
                    do {
                        try await viewModel.signUp()
                        showOnboarding = true
                        //showSignInView = false
                    } catch {
                        print("Error signing up: \(error.localizedDescription)")
                        errorMessages = error.localizedDescription
                    }
                }
            }) {
                Text("Sign up")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor2)
                    .cornerRadius(50)
            }
        }
    )}
}

#Preview {
    SignUpConfirmationButton(viewModel: RegisterViewModel(), errorMessages: .constant("No errors"), showSignInView: .constant(false), showOnboarding: .constant(false))
}
