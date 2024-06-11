//
//  RegisterViewModel.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 04.03.2024.
//

import SwiftUI
import FirebaseAuth
import Firebase

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password are required")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print("successfully signed up")
        let user = DBUser(auth: returnedUserData, displayName: displayName)
        try await UserManager.shared.createNewUser(user: user)

    }

}

