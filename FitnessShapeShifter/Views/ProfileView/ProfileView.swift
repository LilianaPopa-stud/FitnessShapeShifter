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
    func saveUserProfile() throws {
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
    
    
    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack {
                    ProfilePicView(imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqYwDFciXUM91OfgdrjzDYHaxX66xQtYqHCw&usqp=CAU")
                    //.padding(.top,30)
                    
                    Text("\(viewModel.user?.displayName ?? "Guest")")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(String(describing: viewModel.user?.email ?? "Guest"))")
                        .font(.caption)
                        .padding(.bottom, 10)
                    // edit profile button
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
                    
                    Section(header: Text("User Information")) {
                        List{
                            Text(". Age: \(String(describing: viewModel.user?.age))")
                        }
                    }
                }
                    .task {
                        try? await viewModel.loadCurrentUser()
                        try? viewModel.saveUserProfile()
                    }
              
//                .task {
//                    try? await viewModel.loadCurrentUser()
//                }
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
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
        
    }
}
