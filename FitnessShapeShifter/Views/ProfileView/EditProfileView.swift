import SwiftUI
import PhotosUI
import FirebaseStorage

struct EditProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var storageReference = Storage.storage().reference()
    @State var message: String?
    @State private var selectedAgeIndex = 0
    let age = Array(18...99)
    @State private var isSaved = false
    @FocusState private var isHeightFieldFocused: Bool
    @FocusState private var isWeightFieldFocused: Bool
    @State private var ageIndexChanged: Bool = false
    var body: some View {
        NavigationView {
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
                            self.message = "Saved!"
                        case .failure(_):
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
                    TextField("Username",
                              text: $viewModel.fullName,
                              prompt: Text("Username"))
                    .padding(.vertical,5)
                    HStack {
                        Picker("Age", selection: $selectedAgeIndex) {
                            ForEach(0..<age.count) { index in
                                Text("\(age[index])")
                            }
                        }
                        .onChange(of: selectedAgeIndex, {
                            viewModel.age = age[selectedAgeIndex]
                            ageIndexChanged = true
                            
                        })
                        .pickerStyle(DefaultPickerStyle())
                    }
                    HStack {
                        TextField("Height (cm)", value: $viewModel.height, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .focused($isHeightFieldFocused)
                            .onTapGesture {
                                isHeightFieldFocused = true
                            }
                            .onChange(of: viewModel.height) {
                                
                                viewModel.age = age[selectedAgeIndex]
                            }
                            .onSubmit {
                                isHeightFieldFocused = false
                                isWeightFieldFocused = true
                            }
                        TextField("Weight (kg)", value: $viewModel.weight, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .focused($isWeightFieldFocused)
                            .onSubmit {
                                isWeightFieldFocused = false
                                
                            }
                            .onChange(of: viewModel.weight) {
                                viewModel.age = age[selectedAgeIndex]
                            }
                        
                    }
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                try await viewModel.saveEditedProfile(ageIndexChanged: ageIndexChanged)
                                isSaved.toggle()
                            }
                        } label: {
                            if isSaved{
                                Text("Saved!")
                                    .font(.headline)
                                    .task {
                                        await Task.sleep(1_000_000_000)
                                        isSaved.toggle()
                                    }
                            }
                            else{
                                Text("Save")
                                    .font(.headline)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
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
