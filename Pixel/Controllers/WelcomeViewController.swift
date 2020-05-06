//
//  WelcomeViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 06/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseStorage
import FirebaseFirestore

class WelcomeViewController: UIViewController {

    @IBOutlet weak var discoverPhotosButton: RoundButton!
    @IBOutlet weak var toMyAlbumButton: RoundButton!
    @IBOutlet weak var linkToPexels: LinkLabel!
    
    let profileImageViewWidth: CGFloat = 200
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image =  #imageLiteral(resourceName: "DefaultProfileImage").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImageViewWidth / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var profileImageButton: UIButton = {
       
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.cornerRadius = profileImageViewWidth / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func profileImageButtonTapped() {
        showSourceTypeAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        constrainViews()
        loadProfileImage()
    }
    
    func addViews() {
        
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
    }
    
    func constrainViews() {
        
        profileImageView.topToSuperview(offset: 36, usingSafeArea: true)
        profileImageView.centerXToSuperview()
        profileImageView.width(profileImageViewWidth)
        profileImageView.height(profileImageViewWidth)
        
        profileImageButton.edges(to: profileImageView)
    }
    
    func presentAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func loadProfileImage() {
        
        let photoReference = Storage.storage().reference().child(Constants.Keys.photosFolder).child(Constants.Keys.profileImageName)
        
        photoReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            
            if error != nil {
                self.presentAlert(title: "Error", message: "Something went wrong")
            } else {
                let image = UIImage(data: data!)
                self.profileImageView.image = image
            }
        }
    }
    
    func uploadPhotoToFirebase() {
    
        guard let image = profileImageView.image, let data = image.jpegData(compressionQuality: 1.0)
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

}

extension WelcomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
            self.uploadPhotoToFirebase()
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
            self.uploadPhotoToFirebase()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
