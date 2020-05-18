//
//  LoginViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 09/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundButton!
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
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func transitionToWelcomeVC() {
        let welcomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeVC) as? WelcomeViewController
        view.window?.rootViewController = welcomeVC
        view.window?.makeKeyAndVisible()
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validatefields() -> String? {
        
        //Check are all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        return "Please fill in all fields"
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "Wrong password"
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.activityIndicator.alpha = 1
        self.activityIndicator.startAnimating()
        
        //Validate text fields
        let error = validatefields()
        if error != nil {
            //There's something wrong with the fields, show error message
            showError(error!)
        } else {
            //Create cleaned versions of the text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    //Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    let currentUser = Auth.auth().currentUser
                    UserData.email = currentUser!.email!
                    self.transitionToWelcomeVC()
                }
            }
        }
    }
}
