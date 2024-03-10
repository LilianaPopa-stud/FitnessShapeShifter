//
//  LoginResponse.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 12.02.2024.
//

import Foundation

struct LoginResponse: Decodable {
    let data: LoginResponseData
}

struct LoginResponseData: Decodable {
    let accessToken: String
    let refreshToken: String
}
