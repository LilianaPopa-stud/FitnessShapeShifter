//
//  LoginRequest.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 12.02.2024.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
