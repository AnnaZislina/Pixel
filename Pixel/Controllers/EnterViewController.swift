//
//  EnterViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 09/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {
   
    @IBOutlet weak var signUpButton: RoundButton!
    @IBOutlet weak var loginButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "white")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

}
