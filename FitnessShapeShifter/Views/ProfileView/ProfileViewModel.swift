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
    
    
    @Published var uiImageToSave: UIImage? // Added***
    @Published var ImageToSave: Image? // Added***
    @State var data: Data? = nil // Added***
    
    
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
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                
                
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image,uiImageX: uiImage)
                
                
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
                print("imageSelection changer")
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.uiImageToSave = profileImage.uiImageX
                    self.ImageToSave = profileImage.image
                    self.imageState = .success(profileImage.image)
                    self.data = profileImage.uiImageX.jpegData(compressionQuality: 0.3)
                    print("image loaded")
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
    
    func prepareImageUpload() async throws {
        try await loadCurrentUser()
     
    }
    
    
}
