//
//  AddTaskViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 04/12/2020.
//

import UIKit

class AddTaskViewController: UIViewController    {

    
//Var
    var intdata = intData()
    var tagPicker = tagData()
    static var instance: AddTaskViewController?

//IBoutlet
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var enjoymentPicker: UIPickerView!
    @IBOutlet weak var reminderPicker: UIDatePicker!
    @IBOutlet weak var importancePicker: UIPickerView!
    @IBOutlet weak var tagSpinner: UIPickerView!
    @IBOutlet weak var tagColor: UIImageView!
    
//state
    override func viewDidLoad() {
        super.viewDidLoad()
        AddTaskViewController.instance = self
        initPickers()
        // Do any additional setup after loading the view.
    }
   
    func initPickers() {
            //enjoyment Picker
            enjoymentPicker.delegate = intdata
                   enjoymentPicker.dataSource = intdata
            //importance Picker
                   importancePicker.delegate = intdata
                   importancePicker.dataSource = intdata
            //tag Picker
            tagSpinner.delegate = tagPicker
                         tagSpinner.dataSource = tagPicker
    }
  
 
//IBACTION & func
    @IBAction func addBtn(_ sender: Any) {
 
            let selectedValue = importancePicker.selectedRow(inComponent: 0)
            let selectedValue2 = enjoymentPicker.selectedRow(inComponent: 0)
        
        let tagSelected = tagPicker.tags[tagSpinner.selectedRow(inComponent: 0)]
              
        if validation(taskName: taskName.text!, deadline: deadlinePicker.date, reminder: reminderPicker.date){
                      addtask(taskName: taskName.text!, tag: tagSelected, deadline: deadlinePicker.date, importance: selectedValue, reminder: reminderPicker.date, enjoyment: selectedValue2, note: note.text!)
            
        }else{
            let alert = UIAlertController(title: "Validation error", message: " EROOR: \n task name must not be empty and deadline must be > reminder", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "I understand", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       
  
    }
    func addtask(taskName:String,tag:TagModel,deadline:Date,importance:Int,reminder:Date,enjoyment:Int,note:String) {
        let urlString = "https://set-out.herokuapp.com/add_task"
           let url = URL(string:urlString)!
               var request = URLRequest(url: url)
               request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
               request.httpMethod = "POST"
               let parameters: [String: Any] = [
                   "taskName":taskName,
                   "importance":importance+1,
                   "enjoyment":enjoyment+1,
                   "note":note,
                   "dateCreation":Date(),
                   "deadline":deadline,
                   "reminder":reminder,
                   "schedule":false
               ]
        
               request.httpBody = parameters.percentEncoded()

        _ = URLSession.shared.dataTask(with: request) { data, response, error in
                   guard let data = data,
                       let response = response as? HTTPURLResponse,
                       error == nil else {                                              // check for fundamental networking error
                       print("error", error ?? "Unknown error")
                       return
                   }

                   guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                       print("statusCode should be 2xx, but is \(response.statusCode)")
                       print("response = \(response)")
                       return
                   }

                   let responseString = String(data: data, encoding: .utf8)
                   print("responseString = \(responseString)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.showToast(message: "Task added successfully !", font: .systemFont(ofSize: 12.0))
                                   }
              
               }.resume()
     }
    
    func validation(taskName:String,deadline:Date,reminder:Date) -> Bool {
        if taskName.isEmpty{
            return false
        }
        if deadline < reminder{
            return false
        }
        return true
        
    }
 }
    //SubClass
    class intData: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var pickerData: [Int] = [1,2,3,4,5]

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
              return "\(pickerData[row])"
        }
    }

class tagData: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
     var tags: [TagModel] = []
     override init() {
          super.init()
           getAllTags()
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
                             self.tags.append(row)
                         }
                     }catch{
                         print("failed to convert \(error.localizedDescription) ")
                     }
             }.resume()
    }
       

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return tags.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Change image color
        let tagShape = AddTaskViewController.instance?.tagColor
        if let tagColor=tagShape!.image{
                  let colorless = tagColor.withRenderingMode(.alwaysTemplate)
                  tagShape!.image=colorless
            tagShape!.tintColor = UIColor(hexString: tags[row].color!)
              }
        return "\(tags[row].tagName!)"
       }
   }



