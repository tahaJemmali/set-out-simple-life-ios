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
//IBACTION

    
    //functions
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
    func week()  {
        
    }
    
    
  func month()  {
       
   }
      
    func total()  {
         
     }
    

}

