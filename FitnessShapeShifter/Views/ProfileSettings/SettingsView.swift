//
//  SettingsView.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 05.03.2024.
//

import SwiftUI
@MainActor
final class SettingsViewModel: ObservableObject{
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    func resetPassword() async throws {
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
}
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var showAlert = false
    var body: some View {
        List{
            Button("Reset password") {
                Task{
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset email sent")
                    } catch {
                        print("Error reseting password: \(error)")
                    }
                }
            }
            Button("Log out") {
                Task{
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
            }
            Button(action: {
                showAlert = true
            }) {
                Label("Delete account", systemImage: "trash")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            do {
                                try await viewModel.deleteAccount()
                                showSignInView = true
                            } catch {
                                print("Error deleting account: \(error.localizedDescription)")
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingsView(showSignInView: .constant(false))
    }
}
