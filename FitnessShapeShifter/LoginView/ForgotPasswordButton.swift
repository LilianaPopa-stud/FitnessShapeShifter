//
//  ForgotPasswordButton.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 04.03.2024.
//

import SwiftUI

struct ForgotPasswordButton: View {
    @StateObject var viewModel: LoginViewModel
    var body: some View {
        
        NavigationLink(destination: ForgotPasswordView(viewModel: viewModel)){
            Text("Forgot password?")
                .font(.callout)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}


#Preview {
    ForgotPasswordButton(viewModel: LoginViewModel())
}
