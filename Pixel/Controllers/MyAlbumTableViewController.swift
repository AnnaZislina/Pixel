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

class MyAlbumTableViewController: UIViewController {
    
    let cellReuseIdentifier = "myAlbumCell"

    @IBOutlet weak var myAlbumTableView: UITableView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAlbumTableView.delegate = self
        myAlbumTableView.dataSource = self
        myAlbumTableView.rowHeight = UITableView.automaticDimension
        myAlbumTableView.estimatedRowHeight = 400
        
        if let savedImages = Image.loadImages() {
            images = savedImages
        } else {
            images = Image.loadSampleImages()
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
            Image.removeImages()
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
            let image = Image(imageData: selectedImage.pngData()!)
            images.append(image)
            Image.saveImages(images)
            myAlbumTableView.reloadData()
            dismiss(animated: true, completion: nil)
            self.presentAlert(title: "Added!", message: "Image successfully added to album")
        }
    }
    
}
