//
//  SignIn.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 04.03.2024.
//

import SwiftUI

struct SignInLink: View {
    @Binding var showSignInView: Bool
    var body: some View {
        NavigationLink(destination: LoginView(showSignInView: $showSignInView)) {
            HStack(alignment: .center, spacing: 4) {
                Text("Already have an account?")
                    .font(.callout)
                Text("Sign in")
                    .font(.callout)
                    .fontWeight(.heavy)
            }
        }
    }
}

#Preview {
    SignInLink(showSignInView: .constant(false))
}
