//
//  AddProjectViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 05/12/2020.
//

import UIKit

class AddProjectViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
 
 

    //Var
     static var instance: AddProjectViewController?
     var tagss: [TagModel] = []
     var picker:projectTag?
    var tasks:[TaskModel]! = []
    //Outlet
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var tagPicker: UIPickerView!
   
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var projectColor: UIImageView!
    @IBOutlet weak var taskTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //tag Picker
        getAllTasks()
        getAllTags()
    }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tasks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 let cell=tableView.dequeueReusableCell(withIdentifier: "taskCell")
                   let contentView = cell?.contentView
                   let check=contentView?.viewWithTag(1) as! UISwitch
                   let taskName=contentView?.viewWithTag(2) as! UILabel
                    let tagShape=contentView?.viewWithTag(3) as! UIImageView
                   //Change image color
                   if let tagColor=tagShape.image{
                       let colorless = tagColor.withRenderingMode(.alwaysTemplate)
                       tagShape.image=colorless
                       //tagShape.tintColor = UIColor(hexString: tasks[indexPath.row].tag.color)
                   }
                   taskName.text=tasks[indexPath.row].taskName
                   return cell!
        }
        
  
       func getAllTasks()  {
            let url = "https://set-out.herokuapp.com/all_schedules"
                 let urlRequest=URL(string:url)!
                 URLSession.shared.dataTask(with:urlRequest){
                     (data,response,error) in
                         guard let data=data,error==nil else{
                             print("Something went wrong")
                             return
                         }
                         //have data
                         do{
                            let result = try JSONDecoder().decode(AllTasks.self, from: data)
                            let taskList = result.tasks!
                            for row in taskList{
                                self.tasks.append(row)
                                               }
                            DispatchQueue.main.async {
                                self.taskTableView.reloadData()
                                                 }
                           
                         }catch{
                             print("failed to convert \(error.localizedDescription) ")
                         }
                 }.resume()
        }
    
    func validator() -> Bool {
        if projectName.text!.isEmpty{
            return false
        }
       
        if projectName.text!.isEmpty{
             return false
        }
       
        
        return true
    }
    
    func addProj()  {
        let date = Date()
 let dateFormatter = DateFormatter()
        var parameters: [String:Any] = [
                            "projectName":projectName.text!,
                            "description":note.text!,
                            "dateCreation":"2020-11-30T19:02:06.000Z",
                            "tasks":[],
                            "tag":["_id":tagss[tagPicker.selectedRow(inComponent: 0)]._id!,
                                   "tagName":tagss[tagPicker.selectedRow(inComponent: 0)].tagName!,
                                   "color":tagss[tagPicker.selectedRow(inComponent: 0)].color!,
                                   "dateCreation":"2020-11-30T19:02:06.000Z",
                                  ]
              ]
                
                  
        var i:Int = 0
              var existingItems = parameters["tasks"] as? [[String: Any]] ?? [[String: Any]]()
           for row in taskTableView.visibleCells{
               let swit = row.contentView.viewWithTag(1) as! UISwitch
               if swit.isOn{
                  let t:[String:Any] =
                   ["_id": tasks![i]._id!,
                   "taskName": tasks![i].taskName!,
                   "importance": tasks![i].importance!,
                   "enjoyment": tasks![i].enjoyment!,
                   "note": tasks![i].note!,
                   "dateCreation": tasks![i].dateCreation!,
                   "deadline": tasks![i].deadline!,
                   "reminder": tasks![i].reminder!,
                   "schedule": false
                   ]
                   
                   // append the item
                  existingItems.append(t)
               }
               i+=1
           }
               parameters["tasks"] = existingItems
        let url = URL(string: "https://set-out.herokuapp.com/add_project")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        // insert json data to the request
        let headers = [ "Content-Type": "application/json" ]
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
     
        print(jsonData!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
                DispatchQueue.main.async {
                                  self.dismiss(animated: true, completion: nil)
                                  self.showToast(message: "Task added successfully !", font: .systemFont(ofSize: 12.0))
                                                 }
            }
        }

        task.resume()
    }
    
    
    func getAllTags()  {
        let url = "https://set-out.herokuapp.com/all_tags"
             let urlRequest=URL(string:url)!
             URLSession.shared.dataTask(with:urlRequest){
                 (data,response,error) in
                     guard let data=data,error==nil else{
                         print("Something went wrong")
                         return
                     }
                     //have data
                     do{
                        let result = try JSONDecoder().decode(AllTags.self, from: data)
                        let tagList = result.tags as [TagModel]?
                       
                         for row in tagList!{
                             self.tagss.append(row)
                         }
                        DispatchQueue.main.async {
                            self.picker = projectTag(tags:self.tagss,circle: self.projectColor)
                                                  self.tagPicker.delegate = self.picker
                                                  self.tagPicker.dataSource = self.picker
                                             }
                       
                     }catch{
                         print("failed to convert \(error.localizedDescription) ")
                     }
             }.resume()
    }

    @IBAction func addProject(_ sender: Any) {
        if validator() {
            addProj()
        }else{
            let alert = UIAlertController(title: "Validation error", message: " EROOR: \n Project name and note must not be empty ", preferredStyle: UIAlertController.Style.alert)
                             alert.addAction(UIAlertAction(title: "I understand", style: UIAlertAction.Style.default, handler: nil))
                             self.present(alert, animated: true, completion: nil)
        }
          
    }
    
}
class projectTag: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
     var tagss: [TagModel] = []
    var tagShape:UIImageView!
    init(tags:[TagModel],circle:UIImageView) {
        self.tagss = tags
        tagShape = circle
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
                                             return 1
                                        }
                                        
func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return tagss.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       //Change image color
  
          if let tagColor = tagShape.image{
                 let colorless = tagColor.withRenderingMode(.alwaysTemplate)
                 tagShape!.image=colorless
           tagShape!.tintColor = UIColor(hexString: tagss[row].color!)
             }
       return "\(tagss[row].tagName!)"
      }
    
}
