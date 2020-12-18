
import UIKit
import SVProgressHUD

class HeaderViewController: UIViewController {
    
    static var image = UIImage()
    private var currentButton:UIButton?

    private lazy var pickerController : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        
        return picker
    }()
    
    var delegate: myProtocol?
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var coverImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var covermageView: UIImageView!
    @IBOutlet weak var titleView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var gradientView: UIView!

    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)

    var titleInitialCenterY: CGFloat!
    var covernitialCenterY: CGFloat!
    var covernitialHeight: CGFloat!
    var stickyCover = true
    
    var viewDidLayoutOnce = false
    
    @IBAction func editPhotoAction(_ sender: UIButton) {
        print("edit photo")
        currentButton = sender
        present(pickerController, animated: true)
        
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        loadImageProfil()
        
        pickerController.delegate = self

        super.viewDidLoad()
       
        animator.addAnimations {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        
        covermageView.layer.zPosition = 0.1
        visualEffectView.layer.zPosition = covermageView.layer.zPosition + 0.1
        titleView.layer.zPosition = visualEffectView.layer.zPosition + 0.1
        userImageView.layer.zPosition = titleView.layer.zPosition

        visualEffectView.effect = nil

        userImageView.rounded()
        userImageView.bordered(lineWidth: 8)
        
        descriptionLabel.numberOfLines = 2
        
        //me
        let firstName = UserModel.shared.firstName ?? " "
        let lastName = UserModel.shared.lastName ?? " "
        //profileNameLabel.text = firstName + "'s " + "profile"
        userNameLabel.text = firstName + "'s " + "profile"//+ " " + lastName
        
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.numberOfLines = 0
            self.gradientView.isHidden = true
        }
        
        
    }
    
    @IBAction func settiingsButton(_ sender: Any) {
        self.delegate?.doAction()
//        if let currentVC = UIApplication.topViewController() as? ProfileViewController {
//            currentVC.self.performSegue(withIdentifier: "settingsSegue", sender: currentVC.self)
//        }
    }
    
    func loadImageProfil() {
        
        var urlImage : String?
        let photo = UserModel.shared.photo!

//        if photo.contains("Not mentioned") {
//            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
//        }else if photo.hasPrefix("/") {
//            if let data = Data(base64Encoded: photo, options: .ignoreUnknownCharacters){
//                self.covermageView.image = UIImage(data: data)
//                //return iv
//                }
//        }
//        else{
//            urlImage = UserModel.shared.photo
//        }
//
//        let url = URL(string: urlImage!)
//
//        let data = try? Data(contentsOf: url!)
//        self.covermageView.image = UIImage(data: data!)
        
        //return iv
        
        
        
       /*
        if photo.contains("Not mentioned") {
            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
        }
        else{
            urlImage = UserModel.shared.photo
        }
        
        let url = URL(string: urlImage!)

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                if(data == nil){
                }else{
                    DispatchQueue.main.async {
                        self.covermageView.image = UIImage(data: data!)
                        return
                    }
                }
            }
        */
        
        if (photo != "Not mentioned"){
            self.covermageView.image = convertBase64StringToImageFromAndroid(encoded:(photo))
        }else if photo.contains("Not mentioned") {
            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
            let url = URL(string: urlImage!)

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    if(data == nil){
                    }else{
                        DispatchQueue.main.async {
                            self.covermageView.image = UIImage(data: data!)
                            return
                        }
                    }
                }
        }
        
    }
    
    func convertBase64StringToImageFromAndroid(encoded:String) -> UIImage{
        if let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters){
            return UIImage(data: data)!
    }
        return UIImage()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        titleView.setContentOffset(CGPoint(x: 0, y: -titleView.frame.height), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !viewDidLayoutOnce{
            viewDidLayoutOnce = true
            covernitialCenterY = covermageView.center.y
            covernitialHeight = covermageView.frame.height
            titleInitialCenterY = titleView.center.y
        }

    }
    
    @IBAction func readMoreAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.numberOfLines = 0
            self.gradientView.isHidden = true
        }
    }
    
    func updateUserPhoto(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Updating profile image...")
        let imageData = self.covermageView.image!.jpegData(compressionQuality: 0.1)
        
            var imageBase64String = imageData?.base64EncodedString()
            if (imageBase64String == nil){
                imageBase64String = "noImage"
            }
        UserModel.shared.photo = imageBase64String
        
            var json: String?
            let userEmail : String = UserModel.shared.email!
            let parameters: [String: String] = ["user_email": userEmail, "photo":imageBase64String!]
                //create the url with URL
                let url = URL(string: "http://localhost:3000/updateUserPhoto")!
                //let url = URL(string: "https://set-out.herokuapp.com/register")!
                //create the session object
                let session = URLSession.shared
                //now create the URLRequest object using the url object
                var request = URLRequest(url: url)
                request.httpMethod = "PUT" //set http method as PUT
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

                } catch let error {
                    print(error.localizedDescription)
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                //create dataTask using the session object to send data to the server
                let task = session.dataTask(with: request, completionHandler: { data, response, error in
                    guard error == nil else {
                        return
                    }
                    do {
                            json = String(data: data!,encoding: .utf8)
                    }
                    DispatchQueue.main.async {
                        if (json!.contains("Done")){
                            SVProgressHUD.dismiss()
                            print("dine")
                        }
                    }
                })
                task.resume()
        
    }
    
    func update(with progress: CGFloat, minHeaderHeight: CGFloat){

        let y = progress * (view.frame.height - minHeaderHeight)
        
        coverImageHeightConstraint.constant = max(covernitialHeight, covernitialHeight - y)
                
        let titleOffset = max(min(0, (userNameLabel.convert(userNameLabel.bounds, to: nil).minY - minHeaderHeight)), -titleView.frame.height)
        titleView.contentOffset.y = -titleOffset-titleView.frame.height
        
        if progress < 0 {
            animator.fractionComplete = abs(min(0, progress))
        }else{
            animator.fractionComplete = (abs((titleOffset)/(titleView.frame.height)))
        }
        
        let topLimit = covernitialHeight - minHeaderHeight
        if y > topLimit{
            covermageView.center.y = covernitialCenterY + y - topLimit
            if stickyCover{
                self.stickyCover = false
                userImageView.layer.zPosition = 0
            }
        }else{
            covermageView.center.y = covernitialCenterY
            let scale = min(1, (1-progress*1.3))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyCover{
                self.stickyCover = true
                userImageView.layer.zPosition = titleView.layer.zPosition
            }
        }
        visualEffectView.center.y = covermageView.center.y
        titleView.center.y = covermageView.frame.maxY - titleView.frame.height/2
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension HeaderViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        self.covermageView.image = image
        self.updateUserPhoto()
        //currentButton?.setBackgroundImage(image, for: .normal)
        
    }
}
