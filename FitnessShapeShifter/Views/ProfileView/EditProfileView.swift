/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main content view of the app.
*/

import SwiftUI
import PhotosUI
import FirebaseStorage

struct EditProfileView: View {
    var body: some View {
        #if os(macOS)
        ProfileForm()
            .labelsHidden()
            .frame(width: 400)
            .padding()
        #else
        NavigationView {
            ProfileForm()
        }
        #endif
    }
}

struct ProfileForm: View {
    @StateObject var viewModel = ProfileViewModel()
    let storageReference = Storage.storage().reference().child("\(UUID().uuidString)")

       var body: some View {
           Form {
               Section {
                   HStack {
                       Spacer()
                       EditableCircularProfileImage(viewModel: viewModel)
                       Spacer()
                   }
               }
               .listRowBackground(Color.clear)
               #if !os(macOS)
               .padding([.top], 10)
               #endif
               Section {
                   TextField("Full Name",
                             text: $viewModel.fullName,
                             prompt: Text("First Name"))
               }
               Section {
                   TextField("About Me",
                             text: $viewModel.aboutMe,
                             prompt: Text("About Me"))
               }
           }
           .navigationTitle("Account Profile")
       }

}

#Preview{
    EditProfileView()
}
