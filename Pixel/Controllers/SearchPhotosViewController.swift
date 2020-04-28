//
//  SearchPhotosViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 14/12/2019.
//  Copyright © 2019 Anna Zislina. All rights reserved.
//

import Foundation
import UIKit

class SearchPhotosViewController: UIViewController {
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var photos: [Photo] = []
    var selectedIndex = 0
    var currentSearchTask: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! DetailedViewController
            detailVC.photo = photos[selectedIndex]
        }
    }
}

//MARK: Search Bar Delegate
extension SearchPhotosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        currentSearchTask?.cancel() //wasted network calls
        currentSearchTask = PexelsAPI.search(query: searchText, completion: { (photos, error) in
            self.photos = photos
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

//MARK: Table View Delegate, Table View Data Source
extension SearchPhotosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableViewCell
        let photo = photos[indexPath.row]
        cell.photographerLabel?.text = ("Photographer: \(photo.photographer)")
        cell.photoView.downloadImage(urlString: photo.src.large2x)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
