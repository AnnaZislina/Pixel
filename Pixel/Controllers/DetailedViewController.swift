//
//  DetailedViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 02/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import Firebase

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var detailedSizeLabel: UILabel!
    @IBOutlet weak var saveImageButton: RoundButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    var photo: Photo!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
    }
    
    func downloadImage() {
        
        activityIndicator.startAnimating()
        detailedSizeLabel.text = "Original size: \(photo.width) x \(photo.height)"
        detailedImageView.downloadImage(urlString: photo.src.original) { (error) in
            if error == error {
               // print("")
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    func userInteractionAllowed() {
        saveImageButton.alpha = 1
        detailedImageView.alpha = 1
        addToFavoritesButton.alpha = 1
        saveImageButton.isUserInteractionEnabled = true
        addToFavoritesButton.isUserInteractionEnabled = true
    }
    
    func userInteractionForbidden() {
        saveImageButton.isUserInteractionEnabled = false
        addToFavoritesButton.isUserInteractionEnabled = false
        detailedImageView.alpha = 0.5
        saveImageButton.alpha = 0.5
        addToFavoritesButton.alpha = 0.5
    }
    

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
       
        activityIndicator.stopAnimating()
        if let error = error {
            presentAlert(title: "Error", message: error.localizedDescription)
        } else {
            presentAlert(title: "Saved!", message: "Image saved successfully")
            userInteractionAllowed()
        }
    }
    
    func presentAlert(title: String, message: String) {
        
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func savePhoto() {
        guard let image = detailedImageView.image else { return }
        activityIndicator.startAnimating()
        userInteractionForbidden()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func addToFavorites() {
        
        activityIndicator.startAnimating()
        userInteractionForbidden()
        let dbRef = db.collection("Users").document(UserData.email)
        dbRef.updateData(["favorites":FieldValue.arrayUnion([photo.src.large])]) { error in
            if let error = error {
                self.presentAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.presentAlert(title: "Added!", message: "Image successfully added to Favorites")
                self.userInteractionAllowed()
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        savePhoto()
    }
    
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        addToFavorites()
    }
    
}
