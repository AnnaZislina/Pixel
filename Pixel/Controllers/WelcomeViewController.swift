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
import Kingfisher

class WelcomeViewController: UIViewController {

    @IBOutlet weak var discoverPhotosButton: RoundButton!
    @IBOutlet weak var toMyAlbumButton: RoundButton!
    @IBOutlet weak var linkToPexels: LinkLabel!
    
    let profileImageViewWidth: CGFloat = 100
    
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
    
    func uploadPhotoToFirebase() {
        
        guard let image = profileImageView.image, let data = image.jpegData(compressionQuality: 1.0)
            else {
            presentAlert(title: "Error", message: "Something went wrong")
            return
        }
        
        let photoName = UUID().uuidString
        
        let photoReference = Storage.storage().reference().child(Constants.Keys.photosFolder).child(photoName)
        
        photoReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            
            photoReference.downloadURL { (url, err) in
                if let err = err {
                    self.presentAlert(title: "Error", message: err.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    self.presentAlert(title: "Error", message: "Something went wrong")
                    return
                }
                
                let dataRef = Firestore.firestore().collection(Constants.Keys.photosCollection).document()
                let documentUID = dataRef.documentID
                let urlString = url.absoluteString
                let data = [Constants.Keys.uid:documentUID, Constants.Keys.photoURL:urlString]
                
                dataRef.setData(data) { (err) in
                    if let err = err {
                        self.presentAlert(title: "Error", message: err.localizedDescription)
                        return
                    }
                    self.presentAlert(title: "Saved!", message: "Image saved successfully")
                }
            }
        }
    }
    
    func downloadFromFirebase() {
        
        guard let uid = UserDefaults.standard.value(forKey: Constants.Keys.uid) else {
            self.presentAlert(title: "Error", message: "Something went wrong")
            return
        }
        
        let query = Firestore.firestore().collection(Constants.Keys.photosCollection).whereField(Constants.Keys.uid, isEqualTo: uid)
        
        query.getDocuments { (snapshot, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot,
                let data = snapshot.documents.first?.data(),
                let urlString = data[Constants.Keys.photoURL] as? String,
                let url = URL(string: urlString) else {
                self.presentAlert(title: "Error", message: "Something went wrong")
                return
            }
            
            let resourse = ImageResource(downloadURL: url)
            
            self.profileImageView.kf.setImage(with: resourse) { (result) in
                switch result {
                case .success(_):
                    self.presentAlert(title: "Success", message: "Successfully download image from Firebase")
                case .failure(let err):
                    self.presentAlert(title: "Error", message: err.localizedDescription)
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
        let cameraAction = UIAlertAction(title: "Take a New Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.showAlert(style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
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
            //self.uploadPhotoToFirebase()
            //self.downloadFromFirebase()
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
            //self.uploadPhotoToFirebase()
           // self.downloadFromFirebase()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
