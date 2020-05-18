//
//  FavoritesTableViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 06/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class FavoritesTableViewController: UIViewController {
    
    let cellReuseIdentifier = "favoritesCell"

    @IBOutlet weak var favoritesTableView: UITableView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.rowHeight = UITableView.automaticDimension
        favoritesTableView.estimatedRowHeight = 400
        
        let dbRef = db.collection("Users").document(UserData.email)
        dbRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userDict = document.data()!
                let favoriteImages = userDict["favorites"] as! [String]
                if favoriteImages != [] {
                    UserData.favorites = favoriteImages
                    DispatchQueue.main.async {
                        self.favoritesTableView.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadFavorites(_ images: [String]) {
        for element in images {
            print(element)
        }
    }
    
    func removeFromFavorites(_ imageToRemove: String) {
        let dbRef = db.collection("Users").document(UserData.email)
        dbRef.updateData(["favorites": FieldValue.arrayRemove([imageToRemove])]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
            
    func presentAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let imageToRemove = UserData.favorites[indexPath.row]
            self.removeFromFavorites(imageToRemove)
            UserData.favorites.remove(at: indexPath.row)
            favoritesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension FavoritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.favorites.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FavoritesTableViewCell = self.favoritesTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FavoritesTableViewCell
        let image = UserData.favorites[indexPath.row]
        cell.myImageView.downloadImage(urlString: image) { (error) in
            if error != nil {
                    print("Error")
                }
            }
        return cell
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

