//
//  UserInfoHeader.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/6/20.
//


import UIKit

class UserInfoHeader: UIView {
    
    // MARK: - Properties
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        /////////////////////
        
        var urlImage : String?
        let photo = UserModel.shared.photo!
        
        if photo.contains("Not mentioned") {
            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
        }else if photo.hasPrefix("/") {
            if let data = Data(base64Encoded: photo, options: .ignoreUnknownCharacters){
                iv.image = UIImage(data: data)
                return iv
                }
        }
        else{
            urlImage = UserModel.shared.photo
        }
        
        let url = URL(string: urlImage!)
        
        let data = try? Data(contentsOf: url!)
        iv.image = UIImage(data: data!)
        
        return iv
    }()
    
//    func convertBase64StringToImageFromAndroid(encoded:String) -> UIImage{
//        if let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters){
//            return UIImage(data: data)!
//    }
//        return UIImage()
//    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        let firstName = UserModel.shared.firstName ?? " "
        let lastName = UserModel.shared.lastName ?? " "
        label.text = firstName + " " + lastName
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = UserModel.shared.email
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profileImageDimension: CGFloat = 60
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
