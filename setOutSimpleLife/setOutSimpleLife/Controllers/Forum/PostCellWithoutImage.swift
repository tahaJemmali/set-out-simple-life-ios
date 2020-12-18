//
//  PostCell.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/8/20.
//

import UIKit
import FaveButton

class PostCellWithoutImage: UITableViewCell {

    static let PostCellWithoutImage = "PostCellWithoutImage"

    static func nib() -> UINib {
        return UINib(nibName: "PostCellWithoutImage", bundle: nil)
    }
    
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var likesNumber: UILabel!
    
    @IBAction func likeAction(_ sender: Any) {
    }
    
    @IBAction func commentAction(_ sender: Any) {
    }
    
    var post: Post!{
        didSet {
            self.UpdateUI()
        }
    }
    
    func UpdateUI(){

        postTitle.text = post.title
        postDescription.text = post.text
        likesNumber.text = "♥︎ " + String(post.likedBy!.count) + " Likes"

        
        if (post.likedBy!.contains{ $0.email == UserModel.shared.email  }){
            self.likeButton.setSelected(selected: true, animated: false)
        }else{
            self.likeButton.setSelected(selected: false, animated: false)
        }
    }

    
}

