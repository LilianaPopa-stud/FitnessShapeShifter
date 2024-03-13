import SwiftUI
import PhotosUI
import FirebaseStorage

struct Test: View {
    @State var data: Data?
    
    @StateObject var viewModel = ProfileViewModel()
    var storageReference = Storage.storage().reference()
    
    var body: some View {
        VStack {
            Section {
                //                PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                //                    if let imageData = data, let image = UIImage(data: imageData) {
                //                        Image(uiImage: image)
                //                            .resizable()
                //                            .scaledToFit()
                //                            .frame(maxHeight: 300)
                //                    } else {
                //                        Label("Select a picture", systemImage: "photo.on.rectangle.angled")
                //                    }
                CircularProfileImage(imageState: viewModel.imageState)
                    .overlay(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $viewModel.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            Image(systemName: "pencil.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 30))
                                .foregroundColor(.accentColor)
                        }
                                     .buttonStyle(.borderless)
                    }
            }
            .onChange(of: viewModel.imageSelection) {
                //                self.data = viewModel.uiImageToSave?.jpegData(compressionQuality: 0.9)
                self.data = viewModel.uiImageToSave?.jpegData(compressionQuality: 0.1)
                print("UiImageToSave: \(String(describing: viewModel.uiImageToSave))")
                print("ImageToSave: \(String(describing: viewModel.ImageToSave))")
                
                
            }
            Section {
                Button("Upload to Firebase Storage") {
                    if let imageData = data {
                        // Specify metadata for the uploaded image
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg" // Set content type to image/jpeg
                        let imageRef = storageReference.child("\(viewModel.user?.userId ?? "not authenticated").jpg")
                        // Function to post data to Firebase Storage with metadata
                        imageRef.putData(imageData, metadata: metadata) { metadata, error in
                            if let error = error {
                                print("Failed to upload: \(error.localizedDescription)")
                            } else {
                                print("Image uploaded successfully!")
                                // You can perform further actions upon successful upload
                            }
                        }
                    }
                }.disabled(data == nil)
            }
        }
        .onAppear(){
            Task {
                try await viewModel.loadCurrentUser()
            }
        }
    }
}

#if DEBUG
struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
#endif

