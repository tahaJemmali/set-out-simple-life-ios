//
//  ProfileViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/5/20.
//

import UIKit
import TwitterProfile

class ProfileViewController: UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate,myProtocol {
    
    func doAction() {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    var headerVC: HeaderViewController?
    
    let refresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // temp solution
        self.tp_configure(with: self, delegate: self)

    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        self.tp_configure(with: self, delegate: self)
    }*/
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func handleRefreshControl() {
//        print("refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.refresh.endRefreshing()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeaderViewController") as? HeaderViewController
        headerVC!.delegate = self
        return headerVC!
    }
    
    var bottomVC: XLPagerTabStripExampleViewController!
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        bottomVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XLPagerTabStripExampleViewController") as! XLPagerTabStripExampleViewController
        //        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomPageContainerViewController") as! BottomPageContainerViewController
        return bottomVC
    }
    
    //stop scrolling header at this point
    func minHeaderHeight() -> CGFloat {
        return (topInset + 44)
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        headerVC?.update(with: progress, minHeaderHeight: minHeaderHeight())
    }
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        
//        refresh.tintColor = .white
//        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
//
//        let refreshView = UIView(frame: CGRect(x: 0, y: 44, width: 0, height: 0))
//        scrollView.addSubview(refreshView)
//        refreshView.addSubview(refresh)
    }
  
}
