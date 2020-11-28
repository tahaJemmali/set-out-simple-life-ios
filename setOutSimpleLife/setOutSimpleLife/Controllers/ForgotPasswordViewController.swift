//
//  ForgotPasswordViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/24/20.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
 
    func initUI() {

        nextBtn.layer.cornerRadius = 20.0

        assignbackground()
        containerView.layer.cornerRadius=15.0

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
