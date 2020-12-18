//
//  TaskViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 02/12/2020.
//

import UIKit

class TaskViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
//UI
    @IBOutlet weak var projectTableView: UITableView!
    
    //VAR
    var projects:[ProjectModel] = []
    
      
   
//State
    override func viewDidLoad() {
        let url = "https://set-out.herokuapp.com/all_projects"
        getAllProjects(from: url)
        super.viewDidLoad()
    

    }
    func getAllProjects(from url:String){
        let urlRequest=URL(string:url)!
        URLSession.shared.dataTask(with:urlRequest){
            (data,response,error) in
                guard let data=data,error==nil else{
                    print("Something went wrong")
                    return
                }
                //have data
                do{
                   let result = try JSONDecoder().decode(AllProject.self, from: data)
                    let projets = result.projects as [ProjectModel]?
                 
                    for row in projets!{
                        self.projects.append(row)
                    }
                      DispatchQueue.main.async {
                              self.projectTableView.reloadData()
                          }
                }catch{
                    print("failed to convert \(error.localizedDescription) ")
                }
        }.resume()
      
    }
    
    
//Class
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "projectCell")
        let contentView = cell?.contentView
        let taskLabel=contentView?.viewWithTag(1) as! UILabel
        let desriptionLabel=contentView?.viewWithTag(2) as! UILabel
         let tagShape=contentView?.viewWithTag(3) as! UIImageView
        //Change image color
        if let tagColor=tagShape.image{
            let colorless = tagColor.withRenderingMode(.alwaysTemplate)
            tagShape.image=colorless
            tagShape.tintColor = UIColor(hexString: projects[indexPath.row].tag.color)
        }
        taskLabel.text=projects[indexPath.row].projectName
         desriptionLabel.text=projects[indexPath.row].description
        return cell!
        
      }

    
    @IBAction func addTag(_ sender: Any) {
    }
    @IBAction func addProject(_ sender: Any) {
    }
    @IBAction func addTask(_ sender: Any) {
        
    }
    

}
