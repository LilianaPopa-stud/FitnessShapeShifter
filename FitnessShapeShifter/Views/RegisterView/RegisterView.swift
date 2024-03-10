//
//  CreateAccountView.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 07.02.2024.
//

import SwiftUI
import Foundation

struct RegisterView: View {
    @Binding var showSignInView: Bool
    @ObservedObject var viewModel: RegisterViewModel = RegisterViewModel()
    @State var errorMessage: String?
    @State var buttonTitle: String = "Sign up"
    
    @FocusState private var fullNameFocused: Bool
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var isKeyboardVisible: Bool = false
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    var body: some View {
        
        NavigationView {
            ZStack {
                AppBackground()
                // foreground
                ScrollView {
                    VStack {
                        Image("logo")
                            .resizable()
                            .frame(maxWidth:80,maxHeight: 80, alignment:.center)
                            .padding(.vertical,30)
                        
                        Text("Create an account")
                            .font(Font.custom("Bodoni 72", size: 40))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        Text("Please enter your details below")
                            .font(.subheadline)
                            .padding()
                            .foregroundStyle(.secondary)
                        // full name
                        CustomTextField(sfIcon: "person", hint: "Full Name", value: $viewModel.displayName)
                            .focused($fullNameFocused)
                            .keyboardType(.default)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .onTapGesture {
                                fullNameFocused = true
                            }
                            .onSubmit {
                                fullNameFocused = false
                                emailFocused = true
                            }
                            .padding(.bottom,5)
                        
                        //email
                        CustomTextField(sfIcon: "at", hint: "Email", value: $viewModel.email)
                            .focused($emailFocused)
                            .keyboardType(.default)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .onSubmit {
                                emailFocused = false
                                fullNameFocused = false
                                passwordFocused = true
                            }
                            .padding(.bottom,5)
                        // password
                        CustomTextField(sfIcon: "lock", hint: "Password", value: $viewModel.password,isPasswordField: true) // passwordField to true later on
                            .focused($passwordFocused)
                            .keyboardType(.default)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .onSubmit {
                                self.passwordFocused = false
                            }
                        
                        
                        HStack {
                            Text("Use 6 or more characters")
                                .font(.caption)
                                .fontWeight(.thin)
                                .padding(.leading, 20)
                                .padding(.top, 5)
                            Spacer()
                        }
                        // sign up button
                        SignUpConfirmationButton(viewModel: viewModel, errorMessages: $errorMessage, showSignInView: $showSignInView)
                            .disableWithOpacity( viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.displayName.isEmpty)
                            .padding(.top, 10)
                        
                        if errorMessage != nil {
                            Text(errorMessage!)
                                .foregroundColor(.red)
                            
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .scrollTargetBehavior(.paging)
                .safeAreaPadding(.horizontal, 10)
                // sign in link
                VStack{
                    Spacer()
                    SignInLink(showSignInView: $showSignInView)
                        .opacity(isKeyboardVisible ? 0 : 1)
                        .padding(.bottom, 20)
                    
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.keyboardHeight = keyboardFrame.height
                        self.isKeyboardVisible = true
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    self.isKeyboardVisible = false
                }
            }
        } } }



#Preview {
    RegisterView(showSignInView: .constant(false))
}
