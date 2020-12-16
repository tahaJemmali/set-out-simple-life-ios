//
//  HomeViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 11/25/20.
//

import UIKit

class HomeViewController: UIViewController {

    var name:String?

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = UserModel.shared.firstName
    }
    


}
