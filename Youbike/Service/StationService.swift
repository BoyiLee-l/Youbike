//
//  WeatherService.swift
//  WeatherReport
//
//  Created by Jack on 6/25/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

struct Resource<T: Decodable> {
    let url: URL
}

class StationService {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print("error",error)
                completion(.failure(error))
            }
        }.resume()
    }
}

