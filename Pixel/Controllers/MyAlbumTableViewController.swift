//
//  MyAlbumTableViewController.swift
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
import Kingfisher

class MyAlbumTableViewController: UIViewController {
    
    let cellReuseIdentifier = "myAlbumCell"

    @IBOutlet weak var myAlbumTableView: UITableView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var images: [AlbumImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAlbumTableView.delegate = self
        myAlbumTableView.dataSource = self
        myAlbumTableView.rowHeight = UITableView.automaticDimension
        myAlbumTableView.estimatedRowHeight = 400
        
        if let savedImages = AlbumImage.loadImages() {
            images = savedImages
        } else {
            images = AlbumImage.loadSampleImages()
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
            AlbumImage.removeImage(images[indexPath.row])
            images.remove(at: indexPath.row)
            myAlbumTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        showSourceTypeAlert()
    }
    
}

extension MyAlbumTableViewController: UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyImageTableViewCell = self.myAlbumTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MyImageTableViewCell
        
        cell.myImageView.image = UIImage(data: images[indexPath.row].imageData!)
        
        func loadAlbumImages() {

            let photoReference = Storage.storage().reference().child(Constants.Keys.photosFolder).child(Constants.Keys.profileImageName)

            photoReference.getData(maxSize: 1 * 1024 * 1024) { data, error in

                if error != nil {
                    self.presentAlert(title: "Error", message: "Something went wrong")
                } else {
                    let image = UIImage(data: data!)
                    cell.myImageView.image = image
                }
            }
        }

        func uploadToFirebase() {

            guard let image = cell.myImageView.image, let data = image.jpegData(compressionQuality: 1.0)
             else {
                presentAlert(title: "Error", message: "Something went wrong")
                return
            }

            let photoReference = Storage.storage().reference().child(Constants.Keys.photosFolder).child(Constants.Keys.profileImageName)

                photoReference.putData(data, metadata: nil) { (metadata, err) in
                    if let err = err {
                        self.presentAlert(title: "Error", message: err.localizedDescription)
                        return
                    }
                    self.presentAlert(title: "Saved!", message: "Profile image saved successfully")
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
}

extension MyAlbumTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func showSourceTypeAlert() {
        let photoLibraryAction = UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.showAlert(style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = AlbumImage(imageData: selectedImage.pngData()!)
            // Add selected image to album
            images.append(image)
            // Save the whole album to URL Archive
            AlbumImage.saveImages(images)
            myAlbumTableView.reloadData()
            dismiss(animated: true, completion: nil)
            self.presentAlert(title: "Added!", message: "Image successfully added to album")
            
        }
    }
    
}
