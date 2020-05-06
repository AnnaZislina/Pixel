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
            activityIndicator.isHidden = true
        setUpElements()
    }
    
    func setUpElements() {
        
        //Hide the error label
        errorLabel.alpha = 0
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validatefields() -> String? {
    
        //Check are all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        return "Please fill in all fields"
        }
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a letter, a special character and a number."
        }
        return nil
    }
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        //Validate text fields
        let error = validatefields()
        
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
        
            //Create cleaned versions of the text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            //Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    //Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                
                let welcomeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeVC) as? WelcomeViewController
                
                self.view.window?.rootViewController = welcomeVC
                self.view.window?.makeKeyAndVisible()
                
                }
            }
        }
    }
}
