//
//  RequestService.swift
//  PlacesApp
//
//  Created by Hariharan on 30/09/20.
//  Copyright © 2020 Hariharan. All rights reserved.
//

import Foundation
import Alamofire

final class RequestService {
    static let shared = RequestService()
    
    private init () {}
    
    func loadPlaces(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if urlString.isEmpty {
            return
        }
        AF.request(urlString).responseData { response in
            debugPrint("Response: \(String(describing: response.error)) response:\(response)")
            if let error = response.error {
                completion(.failure(error))
                return
            }
            if let data = response.data {
                completion(.success(data))
            }
        }
    }
}

extension FileManager {
    
    static func readJson(forResource fileName: String ) -> Data? {
        let bundle = Bundle(for: RequestService.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        
        return nil
    }
}
