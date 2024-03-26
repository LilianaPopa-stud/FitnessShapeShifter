import SwiftUI
import PhotosUI
import FirebaseStorage

struct EditProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var storageReference = Storage.storage().reference()
    @State var message: String?
    
    var body: some View {
        VStack {
            EditableCircularProfileImage(viewModel: viewModel)
                .padding()
                .onChange(of: viewModel.uiImage) {
                    message = nil
                }
            Button() {
                viewModel.uploadImage { result in
                    switch result {
                    case .success:
                        print("Upload successful")
                        self.message = "Saved!"
                        
                    case .failure(let error):
                        print("Upload failed with error: \(error.localizedDescription)")
                        self.message = "Upload failed, please try again."
                    }
                    if message == "Saved!"{
                        Task {
                            try await viewModel.saveUserProfileImage()
                        }
                    }
                }
            } label:
            {  if message == nil{
                Text("Save")
                    .font(.headline)
            }
                else if message == "Saved!"{
                    Text("Saved!")
                        .font(.headline)
                        .task {
                        }
                } else
                {
                    Text("Upload failed, please try again.")
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
            .disabled(viewModel.uiImage == nil || message == "Saved!" || message == "Upload failed, please try again.")
            Form {
                Section {
                    TextField("Username",
                              text: $viewModel.fullName,
                              prompt: Text("Username"))
                }
            }
        }
        .onAppear(){
            Task {
                try await viewModel.loadCurrentUser()
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: ProfileViewModel(), storageReference: Storage.storage().reference(), message: "Saved")
}
