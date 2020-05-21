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
    
    func transitionToWelcomeVC() {
         let welcomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeVC) as? WelcomeViewController
         view.window?.rootViewController = welcomeVC
         view.window?.makeKeyAndVisible()
     }
    
    func downloadImage() {
        activityIndicator.startAnimating()
        userInteractionForbidden()
        detailedSizeLabel.text = "Original size: \(photo.width) x \(photo.height)"
        detailedImageView.downloadImage(urlString: photo.src.original) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: "There was an error downloading image. Please try again later.")
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3.0) {
                        self.transitionToWelcomeVC()
                    }
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.userInteractionAllowed()
            }
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
        if error != nil {
            presentAlert(title: "Error", message: "There was an error. Please try again later.")
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
        let dbRef = db.collection("Users").document(UserData.email)
        dbRef.updateData(["favorites":FieldValue.arrayUnion([photo.src.large])]) { error in
            if error != nil {
                self.presentAlert(title: "Error", message: "There was an error. Please try again later.")
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        savePhoto()
    }
    
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        presentAlert(title: "Added!", message: "Image successfully added to Favorites")
        addToFavorites()
    }
    
}
