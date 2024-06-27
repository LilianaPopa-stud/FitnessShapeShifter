
import SwiftUI

struct CustomTextField: View {
    var sfIcon: String? = nil
    let hint: String
    @Binding var value: String
    var isPasswordField: Bool = false
    @State private var showPassword: Bool = true
    
    var body: some View {
        ZStack {
            
            Image(systemName: sfIcon ?? "person")
                .foregroundColor(.black)
                .scaledToFit()
                .frame(height: 20)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isPasswordField {
                if showPassword {
                    SecureField(hint, text: $value)
                        .padding(.leading, sfIcon == nil ? 20 : 40)
                } else {
                    TextField(hint, text: $value)
                        .padding(.leading, sfIcon == nil ? 20 : 40)
                }
                
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundColor(.black)
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        showPassword.toggle()
                    }
                
            } else {
                TextField(hint, text: $value)
                    .padding(.leading, sfIcon == nil ? 20 : 40)
            }
        }
        .frame(height: 57)
        .overlay {
            RoundedRectangle(cornerRadius: 35)
                .inset(by: 0.5)
                .stroke(.gray.opacity(0.5), lineWidth: 1)
            
        }
    }
}


