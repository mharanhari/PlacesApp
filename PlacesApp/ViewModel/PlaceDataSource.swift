//
//  PlaceDataSource.swift
//  PlacesApp
//
//  Created by Hariharan on 30/09/20.
//  Copyright © 2020 Hariharan. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T>: NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class PlaceDataSource: GenericDataSource<PlaceInfo>, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as? PlaceTableViewCell {
        cell.placeInfo = self.data.value[indexPath.row]
        //set the default placeholder image
        cell.titleImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        cell.titleImageView.tintColor = .label
        return cell
        } else { fatalError("DequeueReusableCell failed while casting") }
    }
}
