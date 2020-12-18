//
//  PostsTableViewController.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/8/20.
//

import UIKit
import FaveButton
import SVProgressHUD

class PostsTableViewController: UITableViewController {
    
    var posts:[Post]?
    
    struct Storyboard {
        static let postHeaderCell = "PostHeaderCell"
        static let postHeaderHeight:CGFloat = 57.0
        static let postCellDefaultHeight:CGFloat = 610
        
    }
    
    let refresh = UIRefreshControl()

    @objc func handleRefreshControl() {
        print("refreshing in forum")
        fetchPosts()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.refresh.endRefreshing()
        }
    }
    
    // to remove
    @IBAction func commentsAction(_ sender: Any) {
        //performSegue(withIdentifier: "commentsSegue", sender: self)
    }
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        
        refresh.tintColor = .white
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)

        let refreshView = UIView(frame: CGRect(x: 0, y: 10, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)
    }
    
    @IBAction func addPostAction(_ sender: Any) {
        //self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.fetchPosts()
        super.viewDidLoad()
        //
//        tableView.register(PostCell.nib(), forCellReuseIdentifier: PostCell.postCell)
//        tableView.register(PostCellWithoutImage.nib(), forCellReuseIdentifier: PostCellWithoutImage.PostCellWithoutImage)
        
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
        
        //refresh
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.addSubview(refresh) // not required when using UITableViewController

    }

    func fetchPosts(){
    
        var json: String?

        let url = URL(string: "http://localhost:3000/getPosts")!
            //let url = URL(string: "https://set-out.herokuapp.com/getPosts")!
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
                        
                        self.posts = [Post]()
                        if let postsArray = jsonArray["posts"] as? Array<Dictionary<String,Any>> {
                            for post in postsArray {
                                var singlePost : Post = Post()
                                singlePost.id = ((post["_id"] ?? "Not mentioned" ) as! String)
                                singlePost.image = ((post["image"] ?? "Not mentioned" ) as! String)
                                singlePost.text = ((post["description"] ?? "Not mentioned" ) as! String)
                                singlePost.title = ((post["title"] ?? "Not mentioned" ) as! String)
                                singlePost.postDate = self.getDate(key: ((post["post_date"]) as! String))
                                
                                if let user = post["postedBy"] as? Dictionary<String,Any> {
                                    singlePost.user = User()
                                    singlePost.user?.email = ((user["email"] ?? "Not mentioned" ) as! String)
                                    singlePost.user?.firstName = ((user["firstName"] ?? "Not mentioned" ) as! String)
                                    singlePost.user?.lastName = ((user["lastName"] ?? "Not mentioned" ) as! String)
                                    singlePost.user?.photo = ((user["photo"] ?? "Not mentioned" ) as! String)

                                }
                                
                                singlePost.likedBy = [User]()
                                if let likes = post["likedBy"] as? Array<Dictionary<String,Any>> {
                                    for like in likes {
                                        var userLike = User()
                                        userLike.email = ((like["email"] ?? "Not mentioned" ) as! String)
                                        userLike.firstName = ((like["firstName"] ?? "Not mentioned" ) as! String)
                                        userLike.lastName = ((like["lastName"] ?? "Not mentioned" ) as! String)
                                        userLike.photo = ((like["photo"] ?? "Not mentioned" ) as! String)
                                        singlePost.likedBy!.append(userLike)
                                    }
                                }
                                
                                self.posts!.append(singlePost)
                            }
                        }
                    }
                    }catch let err{
                        print(err.localizedDescription)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                                    }
            })
            task.resume()
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
    
    func convertBase64StringToImageFromAndroid(encoded:String) -> UIImage{
        if let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters){
            return UIImage(data: data)!
    }
        return UIImage()
    }
    
    
}

extension PostsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = posts{
            return 1
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let preview = self.posts?[indexPath.section].image
        
        
        if (!preview!.contains("noImage")){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell",for: indexPath) as! PostCell
            
            cell.postImageView.image = convertBase64StringToImageFromAndroid(encoded:(preview!))
            cell.post = self.posts?[indexPath.section]
            cell.selectionStyle = .none
        
            cell.likeButton.tag = indexPath.section
            cell.commentButton.tag = indexPath.section
            cell.likeButton.addTarget(self, action: #selector(buttonLikeClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(buttonCommentClicked(sender:)), for: UIControl.Event.touchUpInside)

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellWithoutImage",for: indexPath) as! PostCellWithoutImage
            cell.post = self.posts?[indexPath.section]
            cell.selectionStyle = .none
            
            cell.likeButton.tag = indexPath.section
            cell.commentButton.tag = indexPath.section
            cell.likeButton.addTarget(self, action: #selector(buttonLikeClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(buttonCommentClicked(sender:)), for: UIControl.Event.touchUpInside)
            return cell
        }
        
    }
    @objc func buttonCommentClicked(sender:UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath(row: 0, section: buttonRow)
        let postId = self.posts?[indexPath.section].id
        let user_email_post = self.posts?[indexPath.section].user?.email
        if(!sender.isSelected){
            var dictSendData:[String] = []
            dictSendData.append(postId!)
            dictSendData.append(user_email_post!)
            performSegue(withIdentifier: "commentsSegue", sender: dictSendData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "commentsSegue"){
        let dictSendData = sender as! [String]
        let destination = segue.destination as! CommentsViewController
                destination.dictSendData = dictSendData
        }
    }
    
    @objc func buttonLikeClicked(sender:UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath(row: 0, section: buttonRow)
        let preview = self.posts?[indexPath.section].image
 
        if(!sender.isSelected){
            unLikePost(postId:(posts?[buttonRow].id)!,email:UserModel.shared.email!)
            if (!preview!.contains("noImage")){
                let cell = tableView.cellForRow(at: indexPath) as! PostCell
                var x : Int = Int((cell.likesNumber.text?.onlyNumbers()[0].stringValue)!)!
                x=x-1
                let s : String = "♥︎ " + String(x) + " Likes"
                cell.likesNumber.text = s
            }else{
                let cell = tableView.cellForRow(at: indexPath) as! PostCellWithoutImage
                var x : Int = Int((cell.likesNumber.text?.onlyNumbers()[0].stringValue)!)!
                x=x-1
                let s : String = "♥︎ " + String(x) + " Likes"
                cell.likesNumber.text = s
            }
        }else{
            likePost(postId:(posts?[buttonRow].id)!,email:UserModel.shared.email!)
            if (!preview!.contains("noImage")){
                let cell = tableView.cellForRow(at: indexPath) as! PostCell
                //var x : Int = (posts?[indexPath.section].likedBy!.count)!
                var x : Int = Int((cell.likesNumber.text?.onlyNumbers()[0].stringValue)!)!
                x=x+1
                let s : String = "♥︎ " + String(x) + " Likes"
                cell.likesNumber.text = s
            }else{
                let cell = tableView.cellForRow(at: indexPath) as! PostCellWithoutImage
                var x : Int = Int((cell.likesNumber.text?.onlyNumbers()[0].stringValue)!)!
                x=x+1
                let s : String = "♥︎ " + String(x) + " Likes"
                cell.likesNumber.text = s
            }
        }
    }
    
    func likePost(postId:String,email:String)  {
        var json: String?
        let parameters: [String: String] = ["post_id": postId,"user_liked_email":email]
            
            let url = URL(string: "http://localhost:3000/likePost")!
            //let url = URL(string: "https://set-out.herokuapp.com/passwordRecovery")!
        
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
                   // print(json!)
                }
            })
            task.resume()
    }
    
    func unLikePost(postId:String,email:String)  {
        var json: String?
        let parameters: [String: String] = ["post_id": postId,"user_unLiked_email":email]
            
            let url = URL(string: "http://localhost:3000/unLikePost")!
            //let url = URL(string: "https://set-out.herokuapp.com/passwordRecovery")!
        
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
                    //print(json!)
                }
            })
            task.resume()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
        
        cell.post = self.posts?[section]
            
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
 
    
}

extension String {
    func onlyNumbers() -> [NSNumber] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let charset = CharacterSet.init(charactersIn: " ,")
        return matches(for: "[+-]?([0-9]+([., ][0-9]*)*|[.][0-9]+)").compactMap { string in
            return formatter.number(from: string.trimmingCharacters(in: charset))
        }
    }

    // https://stackoverflow.com/a/54900097/4488252
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: self) else { return nil }
            return String(self[range])
        }
    }
}
