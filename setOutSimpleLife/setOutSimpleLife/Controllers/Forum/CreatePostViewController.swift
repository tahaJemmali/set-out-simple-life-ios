//
//  CreatePostViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/9/20.
//

import UIKit
import SVProgressHUD

class CreatePostViewController: UIViewController {

    
    static var image = UIImage()
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    private var currentButton:UIButton?
    
    private lazy var pickerController : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self

        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.clipsToBounds = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);


    }
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    

    @IBAction func doneButton(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "uploading post...")
        uploadPost()
    }
    
    func uploadPost() {
        let imageData = CreatePostViewController.image.jpegData(compressionQuality: 0.1)
        var imageBase64String = imageData?.base64EncodedString()
        if (imageBase64String == nil){
            imageBase64String = "noImage"
        }
        
        var json: String?
        var userId : String = UserModel.shared.email!
        let parameters: [String: String] = ["user_id": userId, "title": titleTextField.text!,"description":descriptionTextView.text!,"image":imageBase64String!]
            //create the url with URL
            let url = URL(string: "http://localhost:3000/addPost")!
            //let url = URL(string: "https://set-out.herokuapp.com/register")!
            //create the session object
            let session = URLSession.shared
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
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
                    self.backAction()
                    SVProgressHUD.dismiss()
                }
            })
            task.resume()
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func setPhoto(_ sender: UIButton){
        currentButton = sender
        present(pickerController, animated: true)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        CreatePostViewController.image = image
        
        currentButton?.setBackgroundImage(image, for: .normal)
    }
}

extension UIImage {
    var base64EncodedString: String? {
        if let data = self.pngData() {
            return data.base64EncodedString(options: .endLineWithCarriageReturn)
        }
        return nil
    }
}
