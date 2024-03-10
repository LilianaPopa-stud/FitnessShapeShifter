//
//  RegisterViewModel.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 04.03.2024.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password are required")
            return
        }
        
        /*let _ /*returnedUserData*/ =*/ try await AuthenticationManager.shared.createUser(email: email, password: password)
        print("successfully signed up")
    }
//    @Published var fullName: String = ""
//    func register(){
//        RegisterAction(parameters: RegisterRequest(email: email, password: password, fullName: fullName))
//            .call { response in
//                // Register Successfull, navigate to the Home Screen
//                print("Access token", response.data.accessToken)
//            }
//    }
}

