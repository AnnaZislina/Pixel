//
//  SignUpViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 09/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: RoundButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        activityIndicator.alpha = 0
        
        //Setup background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "white")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    // Validate that the password match the criteria
    func isPasswordValid(_ password: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateTheFields() -> String? {
        
        //Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            //Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a letter, a special character and a number"
        }
        return nil
    }
    
    func showError(_ message: String) {
       
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToWelcomeVC() {
        
        let welcomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeVC) as? WelcomeViewController
        
        view.window?.rootViewController = welcomeVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        
        //Validate the fields
        let error = validateTheFields()
        
        if error != nil {
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            //Create cleaned vesions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName  = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                //Check for errors
                if error != nil {
                    //There was an error creating user
                    self.showError(error!.localizedDescription)
                    print("error" + error!.localizedDescription)
                } else {
                    //User was created successfully, now store the first and the last names
                    let db = Firestore.firestore()
                    db.collection("Users").document(email).setData(["firstName":firstName, "lastName":lastName, "email":email, "profilePicture":false, "favorites":[], "uid":result!.user.uid])
                    { (error) in
                        if error != nil {
                            self.showError("Error adding user data. Please restart the app.")
                        }
                    }
                    UserData.email = email
                    self.transitionToWelcomeVC()
                }
            }
        }
    }
    
}
