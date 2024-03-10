//
//  KeyBoardHandler.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 01.03.2024.
//

import Foundation
import SwiftUI
class KeyboardHandler: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var keyboardIsShowing = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            keyboardIsShowing = true
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
        keyboardIsShowing = false
    }
}
