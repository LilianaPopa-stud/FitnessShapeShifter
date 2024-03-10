//
//  LoginViewModel.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 12.02.2024.
//

import SwiftUI
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password are required")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("successfully signed in with email: \(returnedUserData.email ?? "review your credentials")")
        
    }
    
    func forgotPasswordResetLink() async throws {
        
        try await AuthenticationManager.shared.resetPassword(email: self.email)
    }
    
}

