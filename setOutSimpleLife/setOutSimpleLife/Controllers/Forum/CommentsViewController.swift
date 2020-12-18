//
//  CommentsViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/11/20.
//

import UIKit
import SVProgressHUD
import MessageKit
import InputBarAccessoryView
import SwiftWebSocket

struct Message:MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var dateTime:NSDate
    var kind: MessageKind
    var photo : String
    var sentOrRecieved : Bool
    var userName : String
}

struct Sender: SenderType{
    var photo : String
    var senderId: String
    var displayName: String
}

class CommentsViewController: MessagesViewController {

    let ws = WebSocket("ws://localhost:3001")

    func echoTest(){
        //var messageNum = 0
        /*let send : ()->() = {
            messageNum += 1
            let msg = "\(messageNum): \(NSDate().description)"
            print("send: \(msg)")
            ws.send(msg)
        }*/
        
        ws.event.open = {
            print("opened")
            //send()
        }
        ws.event.close = { code, reason, clean in
            //print("close")
            //print(code)
            print(reason)
        }
        
        /*ws.event.error = { error in
            print("error \(error)")
        }*/
        ws.event.message = {
            message in
            if let text = message as? String {
                //print("recved: \(text)")
                print("recived")
                //let json = String(data: text,encoding: .utf8)
            let dataJson = Data(text.utf8)
            do{
            if let jsonArray = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                let message = jsonArray["message"] as! String
                let photo = jsonArray["user_photo"] as! String
                let firstName = jsonArray["firstName"] as! String
                let lastName = jsonArray["lastName"] as! String
                    self.commentsFramework.append(Message(sender: self.selfSender!, messageId: "1", sentDate: Date(), dateTime: NSDate(), kind: .text(message), photo: photo, sentOrRecieved: false, userName: firstName + " " + lastName))
                    self.messagesCollectionView.reloadDataAndKeepOffset()
            }
            }catch let err{
                print(err.localizedDescription)
            }
                
            }
        }
    }
    
    var dictSendData:[String] = []
    var comments : [Comment]?
    private var commentsFramework = [Message]()
    
    //private let selfSender = Sender(photo: UserModel.shared.photo!, senderId: "13", displayName: UserModel.shared.firstName!)
    
    private var selfSender:Sender? {
        return Sender(photo: UserModel.shared.photo!, senderId: "13", displayName: UserModel.shared.firstName!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ws.close()
    }
    var postId : String?
    var userEmailPost : String?
    
    override func viewDidLoad() {
        postId = dictSendData[0]
        userEmailPost = dictSendData[1]
        echoTest()
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.fetchComments(postId:postId!)
        
        super.viewDidLoad()
        setupMessage()
        
        self.messagesCollectionView.scrollToBottom()
        self.messagesCollectionView.scrollToBottom(animated: true)

        
        //self.messagesCollectionView.scrollToBottom(animated: true)

    }
    
    private func setupMessage() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
                layout.setMessageIncomingAvatarSize(.init(width: 55, height: 55))
                layout.setMessageOutgoingAvatarSize(.init(width: 55, height: 55))
            layout.setMessageOutgoingCellBottomLabelAlignment(LabelAlignment.init(textAlignment: NSTextAlignment.right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 70)))
            
            layout.setMessageIncomingCellBottomLabelAlignment(LabelAlignment.init(textAlignment: NSTextAlignment.left, textInsets: UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)))

            //layout.setMessageOutgoingCellBottomLabelAlignment((UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
            //layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment.init(textAlignment: .left, textInsets: .init(top: 0, left: 57, bottom: 0, right: 57)))
            //layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment.init(textAlignment: .right, textInsets: .init(top: 0, left: 57, bottom: 0, right: 57)))

        }

       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()

    }
    
    func fetchComments(postId:String){
        var json: String?

        let url = URL(string: "http://localhost:3000/getComments/"+postId)!
            //let url = URL(string: "https://set-out.herokuapp.com/login/fahd.larayedh@esprit.tn/123")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
        
            request.httpMethod = "GET" //set http method as POST
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    return
                }
                
                do {
                        json = String(data: data!,encoding: .utf8)
                    
                    let dataJson = Data(json!.utf8)
                    
                    do{
                    if let jsonArray = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [String: Any] {
                        //print(jsonArray["message"]!)
                        //print(jsonArray["comments"]!)
                        self.comments = [Comment]()
                        if let commentArray = jsonArray["comments"] as? Array<Dictionary<String,Any>> {
                            for comment in commentArray {
                                var singleComment : Comment = Comment()
                                singleComment.text = ((comment["text"] ?? "Not mentioned" ) as! String)
                                singleComment.commentDate = self.getDate(key: ((comment["comment_date"]) as! String))
                                
                                if let user = comment["user"] as? Dictionary<String,Any> {
                                    singleComment.user = User()
                                    singleComment.user?.firstName = ((user["firstName"] ?? "Not mentioned" ) as! String)
                                    singleComment.user?.lastName = ((user["lastName"] ?? "Not mentioned" ) as! String)
                                    singleComment.user?.photo = ((user["photo"] ?? "Not mentioned" ) as! String)
                                    singleComment.user?.email = ((user["email"] ?? "Not mentioned" ) as! String)
                                }

                                let firstName = singleComment.user?.firstName ?? "Not mentioned"
                                let lastName = singleComment.user?.lastName ?? "Not mentioned"
                                let username = firstName + " " + lastName

                                self.comments!.append(singleComment)
                                
                                if(singleComment.user?.email == UserModel.shared.email){
                                    self.commentsFramework.append(Message(sender: self.selfSender!, messageId: "0", sentDate: Date(), dateTime: singleComment.commentDate!, kind: .text(singleComment.text!), photo: (singleComment.user?.photo)!, sentOrRecieved: true, userName: username))
                                }else{
                                    self.commentsFramework.append(Message(sender: self.selfSender!, messageId: "1", sentDate: Date(), dateTime:singleComment.commentDate!, kind: .text(singleComment.text!), photo: (singleComment.user?.photo)!, sentOrRecieved: false, userName: username))
                                }
                            }
                        }
                    }
                    }catch let err{
                        print(err.localizedDescription)
                    }
                }
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    SVProgressHUD.dismiss()
                }
            })
            task.resume()
    }
    
    func convertBase64StringToImageFromAndroid(encoded:String) -> UIImage{
        if let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters){
            return UIImage(data: data)!
    }
        return UIImage()
    }
    
    func getDate(key:String) -> NSDate {
        let formatter = DateFormatter()

      // Format 1
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: key) {
            return parsedDate as NSDate
      }

      // Format 2
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: key) {
            return parsedDate as NSDate
      }
        return NSDate()
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

extension CommentsViewController:MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        
        //isFromCurrentSender(message: Message(sender: selfSender!, messageId: "", sentDate: Date(), kind: .text("")))
        return selfSender!
        //Sender
        //fatalError("")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        var cmnt =  commentsFramework[indexPath.section]
        return cmnt
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        commentsFramework.count
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        if (Int(message.messageId)!>0){
            return false
        }
        return true
    }
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let differenceInSeconds = Int(NSDate().timeIntervalSince(commentsFramework[indexPath.section].dateTime as Date))
        let textTime = fahd(fahd: differenceInSeconds)
            return NSAttributedString(
              string: textTime,
              attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
              ]
            )
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 30.0
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = commentsFramework[indexPath.section].userName
            return NSAttributedString(
              string: name,
              attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
              ]
            )
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35.0
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        var urlImage : String?
        let photo = commentsFramework[indexPath.section].photo
        

        if photo.contains("Not mentioned") {
            urlImage = "https://graph.facebook.com/10214899562601635/picture?height=1024"
            let url = URL(string: urlImage!)
            let data = try? Data(contentsOf: url!)
            avatarView.image = UIImage(data: data!)
        }
        else if photo.hasPrefix("/") {
            avatarView.image = convertBase64StringToImageFromAndroid(encoded:(photo))
        }
        else{
            urlImage = photo
            avatarView.imageFromServerURL(urlImage!, placeHolder: nil)
        }
        
    }
    
}

extension CommentsViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        let current_user_email = UserModel.shared.email!
        let message = text
        let post_id = postId!
        let user_email_post = userEmailPost!
        
        let firstName = UserModel.shared.firstName!
        let lastName = UserModel.shared.lastName!
        let user_photo = UserModel.shared.photo!
        //let comment_date = Date()
        let isSent = true
        
        let jsonObject: [String: Any] = [
            "current_user_email": current_user_email,
            "message": message,
            "post_id":post_id,
            "user_email_post": user_email_post,
            "firstName":firstName,
            "lastName":lastName,
            "user_photo":user_photo,
            "isSent":isSent
        ]
        
        let string = self.jsonToString(json: jsonObject)
        
        //let send : ()->() = {
            self.ws.send(string)
        //}
        
        messageInputBar.inputTextView.text = nil
        
        //let components = inputBar.inputTextView.components
        
        self.commentsFramework.append(Message(sender: self.selfSender!, messageId: "0", sentDate: Date(), dateTime: NSDate(), kind: .text(text), photo: (UserModel.shared.photo)!, sentOrRecieved: true, userName: UserModel.shared.firstName!))
        
        //self.fetchComments(postId: self.postId!)
        
        self.messagesCollectionView.reloadDataAndKeepOffset()
        
    }
    func jsonToString(json: [String: Any]) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            //print(convertedString ?? "defaultvalue")
            return convertedString!
        } catch let myJSONError {
            print(myJSONError)
        }
        return "nillle"
    }
}
