
import UIKit
import XLPagerTabStrip

class BottomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int = 0
    var pageTitle: String?
    
    var Temp:[cellStruct] = []

    var count = 0

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Temp.count
    }

    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
        
        cell.contentIcon = Temp[indexPath.row].image
        cell.contentTitle = Temp[indexPath.row].title
        cell.contentText = Temp[indexPath.row].text

//        cell.contentText = "page \(pageIndex) row at index \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("didselect at index \(indexPath.row)")
    }
    
}


class cellStruct {
        
    var image: UIImage
    var title: String
    var text:String
    
    init(image: UIImage,title: String,text: String) {
        self.image=image
        self.title=title
        self.text=text
    }
}

extension BottomViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
