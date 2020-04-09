//
//  DetailedViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 02/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var detailedSizeLabel: UILabel!
    @IBOutlet weak var saveImageButton: RoundButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    var photo: Photo!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedSizeLabel.text = "Original size: \(photo.width) x \(photo.height)"
        detailedImageView.downloadImage(urlString: photo.src.original)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
       
        activityIndicator.stopAnimating()
        if let error = error {
            presentAlert(title: "Error", message: error.localizedDescription)
        } else {
            presentAlert(title: "Saved!", message: "Image saved successfully")
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
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        savePhoto()
    }
    
}
