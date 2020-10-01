//
//  PlacesViewController.swift
//  PlacesApp
//
//  Created by Hariharan on 30/09/20.
//  Copyright © 2020 Hariharan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PlacesViewController: UIViewController {
    
    let dataSource = PlaceDataSource()
    let placesTableView = UITableView() // view
    
    lazy var viewModel: PlaceViewModel = {
        let viewModel = PlaceViewModel(dataSource: dataSource)
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureTableView()
        
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.placesTableView.reloadData()
        }
        
        self.viewModel.fetchallPlaces { (title) in
            self.navigationItem.title = title
        }
        
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            // display error ?
            let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    func configureTableView() {
        view.addSubview(placesTableView)
        
        placesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        placesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        placesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        placesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        placesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        placesTableView.estimatedRowHeight = 44.0

        placesTableView.dataSource = self.dataSource
        placesTableView.delegate = self
        placesTableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "placeCell")
    }
}

extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard   let cell = cell as? PlaceTableViewCell,
                let imageUrlString = self.dataSource.data.value[indexPath.row].imageHref,
                let url = URL(string: imageUrlString) else { return }
        cell.titleImageView.af.setImage(withURL: url, cacheKey: imageUrlString)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlaceTableViewCell else { return }
        cell.titleImageView.af.cancelImageRequest()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
