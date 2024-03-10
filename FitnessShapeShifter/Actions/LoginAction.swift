//
//  LoginAction.swift
//  ShapeShifter
//
//  Created by Liliana Popa on 12.02.2024.
//

import Foundation

struct LoginAction {
    var parameters: LoginRequest
    
    func call(completion: @escaping (LoginResponse) -> Void){
        let scheme: String = "https"
        let host: String = "b58c6210-2116-497e-904b-0356e8380032.mock.pstmn.io"
        let path = "/login"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("true", forHTTPHeaderField: "x-mock-match-request-body")
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            // Error: Unable to encode request parameters
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                let response = try? JSONDecoder().decode(LoginResponse.self, from: data)
                
                if let response = response {
                    completion(response)
                } else {
                    // Error: Unable to decode response JSON
                }
            } else {
                // Error: API request failed
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
