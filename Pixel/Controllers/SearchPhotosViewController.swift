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
    
    var activityView: UIActivityIndicatorView?
    
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
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
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
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .medium)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    func transitionToWelcomeVC() {
         let welcomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeVC) as? WelcomeViewController
         view.window?.rootViewController = welcomeVC
         view.window?.makeKeyAndVisible()
     }
}

//MARK: Search Bar Delegate
extension SearchPhotosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        currentSearchTask = PexelsAPI.search(query: searchText, completion: {
            (photos, error) in
            if error != nil {
                self.showActivityIndicator()
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: "You're offline. Please check your connection.")
                    self.hideActivityIndicator()
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 4.0) {
                        self.transitionToWelcomeVC()
                    }
                }
            } else {
                self.hideActivityIndicator()
                self.photos = photos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        cell.activityIndicator.alpha = 1
        cell.activityIndicator.startAnimating()
        let photo = photos[indexPath.row]
        cell.photographerLabel?.text = ("Photographer: \(photo.photographer)")
        cell.photoView.downloadImage(urlString: photo.src.large) { (error) in
            if error != nil {
                print("Error")
            }
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.alpha = 0
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
