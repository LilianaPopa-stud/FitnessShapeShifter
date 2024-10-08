//
//  View+Extensions.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 06.02.2024.
//

import SwiftUI


extension View {

    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
        frame(maxWidth: .infinity, alignment: alignment)
    }
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
        frame(maxHeight: .infinity, alignment: alignment)
    }
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.8 : 1)
    }
}
