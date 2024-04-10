//  WelcomeViewController.swift
//  NextDaySoftMachinTest
//  Created by Sachin on 09/04/24.

import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGradientBackground()
        
    }
    
    //MARK: - Button Actions
    @IBAction func loginBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(named: "blueColour")?.cgColor
        let colorBottom = UIColor(named: "PurpleColour")?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    
}

@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 15 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }
}

@IBDesignable class RoundView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 15 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }
}
