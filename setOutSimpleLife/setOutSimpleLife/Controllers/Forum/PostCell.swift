//
//  PostCell.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/8/20.
//

import UIKit
import FaveButton


class PostCell: UITableViewCell {

    
    static let postCell = "PostCell"

    static func nib() -> UINib {
        return UINib(nibName: "postCell", bundle: nil)
    }
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var commentButton: UIButton!
    
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
                
        postDescription.text = post.text
        postTitle.text = post.title
        likesNumber.text = "♥︎ " + String(post.likedBy!.count) + " Likes"
        
        if (post.likedBy!.contains{ $0.email == UserModel.shared.email  }){
            self.likeButton.setSelected(selected: true, animated: false)
        }else{
            self.likeButton.setSelected(selected: false, animated: false)
        }
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func convertBase64StringToImageFromAndroid(encoded:String) -> UIImage{
        if let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters){
            return UIImage(data: data)!
    }
        return UIImage()
    }
}

