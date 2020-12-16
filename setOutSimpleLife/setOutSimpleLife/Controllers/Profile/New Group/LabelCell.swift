
import UIKit

class LabelCell: UITableViewCell {
    
    static var reuseId = "labelCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var contentTitle: String?{
        didSet{
            title.text = contentTitle
        }
    }
    
    var contentText: String?{
        didSet{
            label.text = contentText
        }
    }
    
    var contentIcon: UIImage?{
        didSet{
            icon.image = contentIcon
            icon.backgroundColor = .clear
        }
    }
}
