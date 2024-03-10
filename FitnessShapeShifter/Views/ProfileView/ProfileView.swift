//
//  ProfileView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//
// put the following code in a new file named ProfileViewModel.swift
import SwiftUI
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataRestult = try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.fetchUser(userId: authDataRestult.uid)
    }
    
}
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                Text("Email: \(String(describing: user.email))")
                Text("Display name: \(String(describing: user.displayName))")
                if let photoURL = user.photoURL {
                    AsyncImage(url: URL(string: photoURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }
                
            }
        }
        .task{
            try? await viewModel.loadCurrentUser()
        }
        
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gearshape")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
