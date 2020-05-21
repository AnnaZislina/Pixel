//
//  FavoritesTableViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 06/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import Firebase

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
            if error != nil {
                self.presentAlert(title: "Error", message: "Check your internet connection")
                self.transitionToWelcomeVC()
            }
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
    
    func transitionToWelcomeVC() {
        let welcomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeVC) as? WelcomeViewController
        view.window?.rootViewController = welcomeVC
        view.window?.makeKeyAndVisible()
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func loadFavorites(_ images: [String]) {
        for element in images {
            print(element)
        }
    }
    
    func removeFromFavorites(_ imageToRemove: String) {
        let dbRef = db.collection("Users").document(UserData.email)
        dbRef.updateData(["favorites":FieldValue.arrayRemove([imageToRemove])]) { error in
            if let error = error {
                self.presentAlert(title: "Error", message: "Error removing image. Please try again later")
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
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
}

