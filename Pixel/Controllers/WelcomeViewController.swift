//
//  WelcomeViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 06/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TinyConstraints

class WelcomeViewController: UIViewController {

    @IBOutlet weak var discoverPhotosButton: RoundButton!
    @IBOutlet weak var toMyAlbumButton: RoundButton!
    @IBOutlet weak var linkToPexels: LinkLabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    let db = Firestore.firestore()
    
    //Setup image view
    let profileImageViewWidth: CGFloat = 250
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "DefaultProfileImage").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImageViewWidth / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //Setup button within image view
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
        
        let userRef = db.collection("Users").document(UserData.email)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userDict = document.data()!
                self.welcomeLabel.text = ("Hello, \(userDict["firstName"]!)!")
                if userDict["profilePicture"] as? Bool == true {
                    self.loadProfileImage()
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func addViews() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
    }
    
    func constrainViews() {
        profileImageView.topToSuperview(offset: 50, usingSafeArea: true)
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
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        
        let photoReference = Storage.storage().reference().child("Profile_Pictures").child(UserData.email + ".jpg")
        photoReference.getData(maxSize: 1 * 512 * 512) { data, error in
            if error != nil {
                self.presentAlert(title: "Error", message: "Something went wrong")
            } else {
                let image = UIImage(data: data!)
                self.profileImageView.image = image
                self.activityIndicator.alpha = 0
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    func userInteractionForbidden() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        discoverPhotosButton.isUserInteractionEnabled = false
        toMyAlbumButton.isUserInteractionEnabled = false
        discoverPhotosButton.alpha = 0.5
        toMyAlbumButton.alpha = 0.5
    }
    
    func userInteractionAllowed() {
        self.discoverPhotosButton.isUserInteractionEnabled = true
        self.toMyAlbumButton.isUserInteractionEnabled = true
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0
        self.discoverPhotosButton.alpha = 1
        self.toMyAlbumButton.alpha = 1
     
    }
    
    func uploadPhotoToFirebase() {
        
        userInteractionForbidden()
        
        guard let image = profileImageView.image, let data = image.jpegData(compressionQuality: 0.5)
            else {
            presentAlert(title: "Error", message: "Something went wrong")
            return
        }
        
        let photoReference = Storage.storage().reference().child("Profile_Pictures").child(UserData.email + ".jpg")
        photoReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            self.presentAlert(title: "Saved!", message: "Profile image saved successfully")
            self.userInteractionAllowed()
            
            let userRef = self.db.collection("Users").document(UserData.email)
            userRef.updateData(["profilePicture": true]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
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
