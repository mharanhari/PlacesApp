//
//  PlaceViewModel.swift
//  PlacesApp
//
//  Created by Hariharan on 30/09/20.
//  Copyright © 2020 Hariharan. All rights reserved.
//

import Foundation
import Alamofire

struct PlaceViewModel {
    
    weak var dataSource: GenericDataSource<PlaceInfo>?
    
    init(dataSource: GenericDataSource<PlaceInfo>?) {
        self.dataSource = dataSource
    }
    
    var onErrorHandling: ((ErrorResult?) -> Void)?

    func fetchallPlaces(completion: @escaping (String) -> Void) {
        let urlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        
        RequestService.shared.loadPlaces(urlString: urlString) { result in
            do {
                let data = try result.get()
                // Update the dataSource
                let isoString = String(data: data, encoding: .isoLatin1)
                if let utf8Data = isoString?.data(using: .utf8), let response = self.parseJson(data: utf8Data) {
                    self.dataSource?.data.value = response.rows.filter({$0.title != nil})
                    completion(response.title)
                }
            } catch let error {
                print(error)
                self.onErrorHandling?(ErrorResult.custom(string: "Error while loading places"))
            }
        }
    }
    
    func parseJson(data: Data) -> PlaceResponse? {
        var response: PlaceResponse?
        do {
            response = try JSONDecoder().decode(PlaceResponse.self, from: data)
        } catch let error {
            print(error)
        }
        return response
    }
}

enum ErrorResult: Error {
    case parser(string: String)
    case custom(string: String)
}
