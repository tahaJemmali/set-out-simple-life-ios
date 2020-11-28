//
//  SignUpViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/19/20.
//


import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    @IBOutlet weak var containerUIView: UIView!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    func initUI() {

        assignbackground()
        signupButton.layer.cornerRadius = 20.0
        containerUIView.layer.cornerRadius=15.0

        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true

    }

    func assignbackground(){
        let background = UIImage(named: "login/LOGIN")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        containerView.addSubview(imageView)
        self.containerView.sendSubviewToBack(imageView)
       }

}
