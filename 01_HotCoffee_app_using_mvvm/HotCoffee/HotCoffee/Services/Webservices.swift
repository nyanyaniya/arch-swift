//
//  Webservices.swift
//  HotCoffee
//
//  Created by chu on 2019/05/26.
//  Copyright © 2019 chu. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class Webservice {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard
                error == nil,
                let data = data else {
                completion(.failure(.domainError))
                return
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    
    }
}
