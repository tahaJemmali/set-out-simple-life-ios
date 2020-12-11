//
//  FinanceViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 06/12/2020.
//

import UIKit
import SwiftChart


class FinanceViewController: UIViewController, UITableViewDataSource,UITableViewDelegate  {
  
    
    
    //VAR
    var data:[Double] = []
    var data2:[Double] = []
    var data3:[Double] = []
    var days:[Date] = []
    var balances:[BalanceModel] = []
    let dateformatter = DateFormatter()
    var balanceId = ""
    static var instance: FinanceViewController?
    //OUTLET
      @IBOutlet weak var tableBalances: UITableView!
       @IBOutlet var viewContainer: UIScrollView!
    @IBOutlet weak var earnedColor: UIImageView!
    @IBOutlet weak var savingColor: UIImageView!
    
    //State
      override func viewDidLoad() {
          dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let tagColor = earnedColor.image{
                     let colorless = tagColor.withRenderingMode(.alwaysTemplate)
                     earnedColor!.image=colorless
            earnedColor!.tintColor = .green
                 }
        if let tagColor = savingColor.image{
                          let colorless = tagColor.withRenderingMode(.alwaysTemplate)
                          savingColor!.image=colorless
                 savingColor!.tintColor = .blue
                      }
          getAllBalances()
           super.viewDidLoad()
      }
    
    //TableView Protocols
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balances.count
        }
        
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell=tableView.dequeueReusableCell(withIdentifier: "balanceCell")
          let contentView = cell?.contentView
          let imageArrow=contentView?.viewWithTag(1) as! UIImageView
          let balance=contentView?.viewWithTag(2) as! UILabel
           let amount=contentView?.viewWithTag(3) as! UILabel
            let remove=contentView?.viewWithTag(4) as! UIButton
        
        balanceId = balances[indexPath.row]._id!
        remove.addTarget(self, action: #selector(deleteButton(_:)), for: .touchUpInside)
        
            balance.text=balances[indexPath.row].balanceName
            if balances[indexPath.row].type != "EARNED"{
                 amount.text="-" +  String(format: "%.1f", balances[indexPath.row].balanceAmount)
                amount.textColor = .red
                imageArrow.image = UIImage(named:"features/balance/redArrow_balance" )
            }else{
                amount.text="+" +  String(format: "%.1f", balances[indexPath.row].balanceAmount)
            }
          return cell!
        }
    
    @objc func deleteButton(_ sender: UIButton){
        let alert = UIAlertController(title: "Remove Balance", message: "Would like to remove this balance ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.deleteButton(id:self.balanceId)
        }))
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
//IBACTION

    
    //functions
    func deleteButton(id:String) {
        guard let url = URL(string: "https://set-out.herokuapp.com/delete_balance/"+id) else {
                print("Error: cannot create URL")
                return
            }
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    DispatchQueue.main.async {
                        self.getAllBalances() 
                                                   let alert1 = UIAlertController(title: "Balance Deleted", message: "The balance is deleted successfully", preferredStyle: .alert)
                                                            alert1.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                                              self.present(alert1, animated: true, completion: nil)
                        self.tableBalances.reloadData()
                                            }
           
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
    }
    
    func initStat()  {
            let size = 50
            viewContainer.showsHorizontalScrollIndicator = true
            viewContainer.contentSize = CGSize(width: days.count * size, height: 220)
            
            let spent = ChartSeries(data2)
            spent.color = .red
            let earned = ChartSeries(data)
            earned.color = .green
            let saving = ChartSeries(data3)
            saving.colors = (
              above: ChartColors.blueColor(),
              below: ChartColors.redColor(),
              zeroLevel: 0
            )
            saving.area = true
        let chart =  Chart(frame: CGRect(x: 0, y: 0, width: days.count * size, height: 220))
            chart.backgroundColor = .white
            chart.add([spent,earned,saving])
        chart.yLabelsFormatter = { String(Int($1)) +  " DNT" }
            chart.xLabelsFormatter = {"Day : " + String(Int(round($1))) }
            viewContainer.addSubview(chart)
            self.view.addSubview(viewContainer)
    }

    func getAllBalances()  {
        let url = "https://set-out.herokuapp.com/all_balances"
               let urlRequest=URL(string:url)!
               URLSession.shared.dataTask(with:urlRequest){
                   (data,response,error) in
                       guard let data=data,error==nil else{
                           print("Something went wrong")
                           return
                       }
                       //have data
                       do{
                          let result = try JSONDecoder().decode(AllBalances.self, from: data)
                          let balanceList = result.balances
                 
                        self.days(balanceList: balanceList, dateformatter: self.dateformatter)
                         DispatchQueue.main.async {
                            self.balances = balanceList
                            self.initStat()
                            self.tableBalances.reloadData()
                            }
                       }catch{
                           print("failed to convert \(error.localizedDescription) ")
                       }
               }.resume()
    }
    
    func days(balanceList:[BalanceModel],dateformatter:DateFormatter) {
        for row in balanceList{
            let date = dateformatter.date(from: row.dateCreation)
            if !days.contains(date!){
                days.append(date!)
            }
        }

        var spent = 0.0
               var earned = 0.0
               var saving = 0.0
        for d in days{
       
            for row in balanceList{
                 let date = dateformatter.date(from: row.dateCreation)
                        if d == date {

                            if row.type != "EARNED"{
                                spent += row.balanceAmount
                            }
                            if row.type == "EARNED"{
                            earned += row.balanceAmount
                            }
                        
                        saving=earned-spent;
                    }
                    }
            data.append(earned)
            data2.append(spent)
            data3.append(saving)
                    }
    }


}

