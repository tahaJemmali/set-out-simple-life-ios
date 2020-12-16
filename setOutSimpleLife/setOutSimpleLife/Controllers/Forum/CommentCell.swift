//
//  CommentCell.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/11/20.
//

import UIKit

class CommentCell: UITableViewCell {

    static let identifier = "CommentCell"

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()

    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)

        userNameLabel.frame = CGRect(x: /*userImageView.right +*/ 10,
                                     y: 10,
                                     width: contentView.frame.width - 20 - userImageView.frame.width,
                                     height: (contentView.frame.height-20)/2)

        userMessageLabel.frame = CGRect(x: /*userImageView.right + */ 10,
                                        y: /*userNameLabel.bottom + */ 10,
                                        width: contentView.frame.width - 20 - userImageView.frame.width,
                                        height: (contentView.frame.height - 20)/2)

    }

    public func configure(with model: Comment) {
        userMessageLabel.text = model.text
        userNameLabel.text = model.user?.email
        
        var urlImage : String?
        let photo = model.user?.photo
        
        if photo!.contains("Not mentioned") {
            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
            let url = URL(string: urlImage!)
            let data = try? Data(contentsOf: url!)
            self.userImageView.image = UIImage(data: data!)
        }
        else{
            urlImage = model.user?.photo
            self.userImageView.imageFromServerURL(urlImage!, placeHolder: nil)
        }
//        let path = "images/\(model.otherUserEmail)_profile_picture.png"
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//
//                DispatchQueue.main.async {
//                    self?.userImageView.sd_setImage(with: url, completed: nil)
//                }
//
//            case .failure(let error):
//                print("failed to get image url: \(error)")
//            }
//        })
    }

}
