//
//  LogInConfirmationButton.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 04.03.2024.
//

import SwiftUI

struct LogInConfirmationButton: View {
    @Binding var showSignInView: Bool
    @ObservedObject var viewModel: LoginViewModel
    @Binding var success: Bool?
    let backgroundColor: Color = .accentColor2
    let fontColor: Color = .white
    var body: some View {
        Button(action: {
            Task{
                do{
                    try await viewModel.signIn()
                    showSignInView = false
                }
                catch{
                    success = false
                    print("Error signing up: \(error.localizedDescription)")
                }
            }

        }
               ,label: {
            VStack {
                Text("Sign in")
            }
            .font(.headline)
            .font(Font.custom("RobotoCondensed-Bold", size: 18))
            .foregroundColor(fontColor)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(backgroundColor)
                    .shadow(color: .shadow, radius: 4, x: 1, y: 3))
        })
        .overlay(alignment: .trailing){
            Image(systemName: "arrow.right")
                .foregroundStyle(.white)
                .padding(.trailing)
        }
    }
}


#Preview {
    LogInConfirmationButton(showSignInView: .constant(false), viewModel: LoginViewModel(), success: .constant(true))
}
