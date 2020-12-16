
import UIKit
import XLPagerTabStrip

class EmptyViewController: UIViewController {
    
    let label = UILabel()
    
    override func loadView() {
        
        let view = UIView()
        
        label.text = "Empty View"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .lightGray
        view.addSubview(label)
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 200)
    }
}

extension EmptyViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Empty")
    }
}
