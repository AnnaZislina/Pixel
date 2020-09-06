//
//  EnterViewController.swift
//  Pixel
//
//  Created by Anna Zislina on 09/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController, CAAnimationDelegate {
   
    @IBOutlet weak var signUpButton: RoundButton!
    @IBOutlet weak var loginButton: RoundButton!
    
    
    //MARK: - Background Gradient
    
    let gradient = CAGradientLayer()
    
    var gradientList = [[CGColor]]() //list of array holding two colors
   
    var currentGradient: Int = 0 //current gradient index
    
    let firstColor = #colorLiteral(red: 0.01622050256, green: 1, blue: 0.8149415851, alpha: 1).cgColor
    let secondColor = #colorLiteral(red: 0.9117158055, green: 0.9573500752, blue: 0.7147992253, alpha: 1).cgColor
    let thirdColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).cgColor
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createGradientView()
    }
    
    func createGradientView() {
        
        //make three sets of colors
        gradientList.append([firstColor, secondColor])
        gradientList.append([secondColor, thirdColor])
        gradientList.append([thirdColor, firstColor])
        
        //set the gradient size to be entire screen
        gradient.frame = self.view.bounds
        gradient.colors = gradientList[currentGradient]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        animateGradient()
    }
    
    func animateGradient() {
        
        //cycle through all the colors
        if currentGradient < gradientList.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientList[currentGradient]
        gradientChangeAnimation.fillMode = .forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientList[currentGradient]
            animateGradient()
        }
    }
    
    
}


