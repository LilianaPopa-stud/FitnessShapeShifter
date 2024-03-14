import SwiftUI
import PhotosUI
import FirebaseStorage

struct EditProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var storageReference = Storage.storage().reference()
    @State var errorMessage: String?
    
    var body: some View {
        VStack {
            EditableCircularProfileImage(viewModel: viewModel)
                .padding()
                .onChange(of: viewModel.uiImage) {
                    errorMessage = nil
                }
            Button() {
                viewModel.uploadImage { result in
                    switch result {
                    case .success:
                        print("Upload successful")
                        self.errorMessage = "Saved!"
                        
                    case .failure(let error):
                        print("Upload failed with error: \(error.localizedDescription)")
                        self.errorMessage = "Upload failed, please try again."
                    }
                    if errorMessage == "Saved!"{
                        Task {
                            try await viewModel.saveUserProfileImage()
                        }
                    }
                }
            } label:
            {  if errorMessage == nil{
                Text("Save")
                    .font(.headline)
            }
                else if errorMessage == "Saved!"{
                    Text("Saved!")
                        .font(.headline)
                } else
                {
                    Text("Upload failed, please try again.")
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
            .disabled(viewModel.uiImage == nil)
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
    EditProfileView(viewModel: ProfileViewModel(), storageReference: Storage.storage().reference(), errorMessage: "Saved")
}
