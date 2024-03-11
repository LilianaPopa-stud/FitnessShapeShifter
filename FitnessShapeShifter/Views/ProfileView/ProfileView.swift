//
//  ProfileView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//
// put the following code in a new file named ProfileViewModel.swift
import SwiftUI
import Swift
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var gender: String = "Female"
    @Published var age: Int = 0
    @Published var weight: Double? = nil
    @Published var height: Double? = nil
    @Published var goal: String = ""
    @Published var activityLevel: String = ""
    @Published var measurementUnit: String = ""
    @Published private(set) var user: DBUser? = nil
    
    init(user: DBUser? = nil) {
        self.user = user
    }
    
    func loadCurrentUser() async throws {
        let authDataRestult = try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.fetchUser(userId: authDataRestult.uid)
    }
    func saveUserProfile() async throws {
        guard let user else { return }
        Task {
            try await UserManager.shared.updateUser(userId: user.userId, age: age, weight: weight ?? 0, height: height ?? 0, gender: gender, goal: goal, activityLevel: activityLevel, measurementUnit: measurementUnit)
            self.user = try await UserManager.shared.fetchUser(userId: user.userId)
            
        }
        
    }
    
    
}
protocol DBUserMock{
    var userId: String { get }
    var email: String? { get }
    var displayName: String? { get }
    var photoURL: String? { get }
    var dateCreated: Date { get }
}
struct MockDBUser: DBUserMock {
    var userId: String = "mockUserId"
    var email: String? = "mockEmail@example.com"
    var displayName: String? = "Mock User"
    var photoURL: String? = nil // Set to nil if there's no photo
    var dateCreated: Date = Date()
}

class MockProfileViewModel: ObservableObject {
    /* @Published private(set)*/ var user: MockDBUser? = MockDBUser()
    
    func loadCurrentUser() async throws {
        // No actual loading required for mock ViewModel
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    // @StateObject private var viewModel = MockProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var refreshProfile = false
    
    
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                ProfilePicView()
                //.padding(.top,30)
                
                Text("\(viewModel.user?.displayName ?? "Guest")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("\(String(describing: viewModel.user?.email ?? "Guest"))")
                    .font(.caption)
                    .padding(.bottom, 10)
                Button(action: {
                    // Handle edit profile action
                }) {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .padding(.horizontal,25)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 1)
                            
                        )}
                .padding(.bottom, 10)
                Divider()
                    .frame(minHeight: 0.5)
                    .background(Color.gray)
                    .padding(.horizontal, 20)
                //                ScrollView {
                //                    VStack(alignment: .leading, spacing: 5) {
                //                        Text("Name: \(viewModel.user?.displayName ?? "Guest")")
                //                        Text("Email: \(viewModel.user?.email ?? "Guest")")
                //                        Text("Member since: \(viewModel.user?.dateCreated ?? Date(), style: .date)")
                //                        Text("Gender: \(viewModel.user?.gender ?? "Unknown")")
                //                        Text("Age: \(viewModel.user?.age ?? 0)")
                //                        Text("Weight: \(viewModel.user?.weight ?? 0.0)")
                //                        Text("Height: \(viewModel.user?.height ?? 0.0)")
                //                        Text("Goal: \(viewModel.user?.goal ?? "")")
                //                        Text("Activity Level: \(viewModel.user?.activityLevel ?? "")")
                //                        Text("Measurement Unit: \(viewModel.user?.measurementUnit ?? "")")
                //                    }
                //
                //                }
                List{
                    
                    Text("Name: \(viewModel.user?.displayName ?? "Guest")")
                    Text("Email: \(viewModel.user?.email ?? "Guest")")
                    Text("Member since: \(viewModel.user?.dateCreated ?? Date(), style: .date)")
                    Text("Gender: \(viewModel.user?.gender ?? "Unknown")")
                    Text("Age: \(viewModel.user?.age ?? 0)")
                    Text("Weight: \(viewModel.user?.weight ?? 0.0)")
                    Text("Height: \(viewModel.user?.height ?? 0.0)")
                    Text("Goal: \(viewModel.user?.goal ?? "")")
                    Text("Activity Level: \(viewModel.user?.activityLevel ?? "")")
                    Text("Measurement Unit: \(viewModel.user?.measurementUnit ?? "")")
                    
                }
            }
                .onAppear(){
                    Task {
                        try? await viewModel.loadCurrentUser()
                        print("din profileView")
                        print(viewModel.user)
                        refreshProfile.toggle()
                    }
                }
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
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
        
    }
}
