

import UIKit
import TwitterProfile
import XLPagerTabStrip

class XLPagerTabStripExampleViewController: ButtonBarPagerTabStripViewController, PagerAwareProtocol {
    
    //MARK: PagerAwareProtocol
    weak var pageDelegate: BottomPageDelegate?
    
    var currentViewController: UIViewController?{
        return viewControllers[currentIndex]
    }
    
    var pagerTabHeight: CGFloat?{
        return 44
    }

    //MARK: Properties
    var isReload = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settings.style.buttonBarBackgroundColor = .background
        settings.style.buttonBarItemBackgroundColor = .background
        settings.style.selectedBarBackgroundColor = Colors.twitterBlue
        settings.style.buttonBarItemTitleColor = Colors.twitterBlue
        settings.style.selectedBarHeight = 3
    }

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = Colors.twitterGray
            newCell?.label.textColor = Colors.twitterBlue
        }
    }

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
        vc.pageIndex = 0
        vc.pageTitle = "Profile"
        vc.Temp = createArray()
        vc.count = createArray().count
        
        let child_1 = vc
        
        /*let vc1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
        vc1.pageIndex = 1
        vc1.pageTitle = "Tweets & replies"
        vc1.count = 1
        let child_2 = vc1
        
        let vc2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
        vc2.pageIndex = 2
        vc2.pageTitle = "Media"
        vc2.count = 10
        let child_3 = vc2
        
        let vc3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
        vc3.pageIndex = 3
        vc3.pageTitle = "Likes"
        vc3.count = 2
        let child_4 = vc3
*/
        return [child_1]
    }

    func createArray() -> [cellStruct] {
        var Temp:[cellStruct] = []
    
            let firstName = UserModel.shared.firstName ?? " "
            let lastName = UserModel.shared.lastName ?? " "
        
        let cellStruct1 = cellStruct(image:UIImage(named: "profile/name")!, title: "Full name",text: firstName + " " + lastName)
        Temp.append(cellStruct1)

        let cellStruct2 = cellStruct(image:UIImage(named: "profile/email")!, title: "Email",text: UserModel.shared.email!)
        Temp.append(cellStruct2)

        
            if UserModel.shared.birth_date != nil {
                let cellStruct3 = cellStruct(image:UIImage(named: "profile/birth_date")!, title: "Date of birth",text: getStringFromDate(date: UserModel.shared.birth_date!))
                Temp.append(cellStruct3)
            }

            let s = UserModel.shared.address!
            if !s.contains("Not mentioned"){
                let cellStruct4 = cellStruct(image:UIImage(named: "profile/address")!, title: "Address",text: UserModel.shared.address!)
                Temp.append(cellStruct4)
            }
        
            let ss = UserModel.shared.phone!
            if !ss.contains("Not mentioned"){
                let cellStruct5 = cellStruct(image:UIImage(named: "profile/phone")!, title: "Phone",text: UserModel.shared.phone!)
                Temp.append(cellStruct5)
                
            }

        let cellStruct6 = cellStruct(image:UIImage(named: "profile/join_date")!, title: "Member since",text: getStringFromDate(date: UserModel.shared.sign_up_date!))
        Temp.append(cellStruct6)

        return Temp
    }
    
    func getStringFromDate(date:NSDate) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let myString = formatter.string(from: date as Date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)

        return myStringafd
        //print(myStringafd)
    }
    
    override func reloadPagerTabStripView() {
        pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        super.reloadPagerTabStripView()
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }

        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.tp_pageViewController(self.currentViewController, didSelectPageAt: toIndex)

    }
}
