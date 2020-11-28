//
//  ConfirmPasswordViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/25/20.
//

import UIKit

class ConfirmPasswordViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    

    func initUI() {
        assignbackground()
        containerView.layer.cornerRadius=15.0
        confirmButton.layer.cornerRadius = 20.0

    }
    

    
    func assignbackground(){
           let background = UIImage(named: "login/LOGIN")
            
            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
       }

}
