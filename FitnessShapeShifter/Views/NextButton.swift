//
//  ButtonModel.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 08.02.2024.
//

import SwiftUI

struct NextButton<Content: View>: View {
    let buttonTitle: String
    let isLast: Bool
    let backgroundColor: Color = Color.accentColor2
    let fontColor: Color = .white
    @Binding var isActive: Bool
    let destination: Content
    var body: some View {
        NavigationLink(destination: destination, label: {
            VStack {
                HStack {
                    Spacer()
                    Text(buttonTitle)
                    if !isLast {
                        Image(systemName: "arrow.right")
                    }
                }
            }
            .font(Font.custom("RobotoCondensed-Bold", size: 20))
            .padding(.trailing, 10)})
    }
}
