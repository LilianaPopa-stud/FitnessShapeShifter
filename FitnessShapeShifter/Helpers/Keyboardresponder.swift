//
//  Keyboardresponder.swift
//  ShapeShifterFitness
//
//  Created by Liliana Popa on 02.03.2024.
//

import Foundation
import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private(set) var currentHeight: CGFloat = 0

    init() {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellables)
    }
}
