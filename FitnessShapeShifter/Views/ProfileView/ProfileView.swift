//
//  ProfileView.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 10.03.2024.
//
// put the following code in a new file named ProfileViewModel.swift
import SwiftUI
import Swift
import PhotosUI
import FirebaseStorage


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
   
    // @StateObject private var viewModel = MockProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var refreshProfile = false
    
    
    var body: some View {
        ZStack {
            AppBackground()
            NavigationView {
                VStack {
                    // Form {
                    Section {
                        HStack {
                            Spacer()
                            CircularProfileImage(imageState: viewModel.imageState)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    //.padding(.top,30)
                    
                    Text("\(viewModel.user?.displayName ?? "Guest")")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(String(describing: viewModel.user?.email ?? "Guest"))")
                        .font(.caption)
                        .padding(.bottom, 10)
                    NavigationLink {
                        EditProfileView()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .padding(.horizontal,25)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blue, lineWidth: 1))
                        
                    }
                    .padding(.bottom, 10)
                    
                    List{
                        
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
//                            SettingsView(showSignInView: $showSignInView)
                            Test()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.headline)
                        }
                    }
                }
            }
            
        }
        .onAppear(){
            Task {
                try? await viewModel.loadCurrentUser()
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
        
    }
}

//protocol DBUserMock{
//    var userId: String { get }
//    var email: String? { get }
//    var displayName: String? { get }
//    var photoURL: String? { get }
//    var dateCreated: Date { get }
//}
//struct MockDBUser: DBUserMock {
//    var userId: String = "mockUserId"
//    var email: String? = "mockEmail@example.com"
//    var displayName: String? = "Mock User"
//    var photoURL: String? = nil // Set to nil if there's no photo
//    var dateCreated: Date = Date()
//}
//
//class MockProfileViewModel: ObservableObject {
//    /* @Published private(set)*/ var user: MockDBUser? = MockDBUser()
//
//    func loadCurrentUser() async throws {
//        // No actual loading required for mock ViewModel
//    }
//}
