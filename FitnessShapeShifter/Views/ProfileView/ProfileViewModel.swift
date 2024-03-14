//
//  ProfileViewModel.swift
//  FitnessShapeShifter
//
//  Created by Liliana Popa on 13.03.2024.
//

import SwiftUI
import Swift
import PhotosUI
import FirebaseStorage

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var aboutMe: String = ""
    @Published var email: String = ""
    @Published var photoURL: String = ""
    @Published var dateCreated: Date?
    @Published var gender: String = "Female"
    @Published var age: Int = 0
    @Published var weight: Double? = nil
    @Published var height: Double? = nil
    @Published var goal: String = ""
    @Published var activityLevel: String = ""
    @Published var measurementUnit: String = ""
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var uiImage: UIImage? = nil // trebuie sa mai adaugi o variabila pentru ca se suprapun si nu mai e butonul de save disabled
    
    init(user: DBUser? = nil) {
        self.user = user
    }
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        let uiImageX: UIImage
        let data: Data
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                
                guard let uiImage = UIImage(data: data)
                else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                print("data in profile image\(data)")
                return ProfileImage(image: image,uiImageX: uiImage, data: data)
                
                
            }
        }
    }
    
    @Published  var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
                print(imageState.self)
                print("imageSelection changed")
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async { [self] in
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                    self.uiImage = profileImage.uiImageX
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
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
    func saveUserProfileImage() async throws {
        guard let user else { return }
        Task {
            try await UserManager.shared.updateUserProfileImage(userId: user.userId, photoURL: photoURL)
            self.user = try await UserManager.shared.fetchUser(userId: user.userId)
        }
    }
    
    func prepareImageUpload() async throws {
        try await loadCurrentUser()
    }
    
    
    enum MyError: Error {
        case noImageData
    }
    
    func uploadImage(completion: @escaping (Result<Void, Error>)  -> Void) {
        var data: Data?
        
        let storageReference = Storage.storage().reference()
        data = self.uiImage?.jpegData(compressionQuality: 0.3)
        
        guard let imageData = data else {
            completion(.failure(MyError.noImageData))
            return
        }
        
        // Specify metadata for the uploaded image
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageRef = storageReference.child("profile_pictures/\(self.user?.userId ?? "not authenticated").jpg")
        
        // Function to post data to Firebase Storage with metadata
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Failed to upload: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Image uploaded successfully!")
                completion(.success(()))
                self.photoURL = "profile_pictures/\(self.user?.userId ?? "not_authenticated").jpg"
                
            }
        }
    }
    
    func downloadImage() {
        let storageReference = Storage.storage().reference()
        if user?.photoURL == nil {
            self.imageState = .empty
            return
        } else {
            let imageRef = storageReference.child(user?.photoURL ?? "not_authenticated")
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Failed to download: \(error.localizedDescription)")
                    self.imageState = .failure(error)
                } else {
                    self.uiImage = UIImage(data: data!)
                    self.imageState =  .success(Image(uiImage: self.uiImage!))
                    
                }
            }
        }
    }
}
