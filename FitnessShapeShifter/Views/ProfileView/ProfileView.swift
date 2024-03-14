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
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(String(describing: viewModel.user?.email ?? "guest@example.com"))")
                        .font(.subheadline)
                         .padding(.bottom, 5)
                    Text("Joined on: \(viewModel.user?.dateCreated ?? Date(), style: .date)")
                        .font(.caption2)
                        .padding(.bottom, 5)
                    NavigationLink {
                        EditProfileView(viewModel: viewModel)
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
                           SettingsView(showSignInView: $showSignInView)
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
                viewModel.downloadImage()
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
