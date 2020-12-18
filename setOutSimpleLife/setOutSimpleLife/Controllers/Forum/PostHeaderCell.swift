//
//  PostHeaderCell.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/8/20.
//

import UIKit

class PostHeaderCell: UITableViewCell {


    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var post: Post!{
        didSet {
            self.UpdateUI()
        }
    }
    
    func UpdateUI(){
        //print("update ui ????")
        //print(post)
        
//        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
//        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        
        let differenceInSeconds = Int(NSDate().timeIntervalSince(post.postDate! as Date))
        postTime.text = fahd(fahd: differenceInSeconds)

        
        var urlImage : String?
        let photo = post.user?.photo
        
        if photo!.contains("Not mentioned") {
            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
            let url = URL(string: urlImage!)
            let data = try? Data(contentsOf: url!)
            profileImageView.image = UIImage(data: data!)
        }else if photo!.hasPrefix("/") {
            profileImageView.image = convertBase64StringToImageFromAndroid(encoded:(photo!))
        }
        else{
            urlImage = post.user?.photo
            self.profileImageView.imageFromServerURL(urlImage!, placeHolder: nil)
        }
        
        nameLabel.text = (post.user?.firstName)! + " " + (post.user?.lastName)!
    }

    func convertBase64StringToImageFromAndroid(encoded:String) -> UIImage{
        if let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters){
            return UIImage(data: data)!
    }
        return UIImage()
    }
    
    func fahd (fahd:Int) -> String {
        
        let days = fahd / 86400
        let hours = fahd / 3600
        let minutes = fahd / 60
        let seconds = fahd
        
        if (days>0) {
                    return "\(days) days ago"
        }else if hours > 0 {
            return "\(hours) hours ago"
        } else if minutes > 0 {
            return "\(minutes) hours ago"
        }else if seconds > 29 {
            return "\(seconds) seconds ago"
        }else{
            return "Just now"
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

        func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {

        self.image = nil
        //If imageurl's imagename has space then this line going to work for this
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
