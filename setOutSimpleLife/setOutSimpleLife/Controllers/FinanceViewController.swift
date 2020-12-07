//
//  FinanceViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 06/12/2020.
//

import UIKit
import SwiftChart


class FinanceViewController: UIViewController, UITableViewDataSource,UITableViewDelegate  {
  
    
    var data = [0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8, 4.1, 7, -3.1, 10, 8, 4.1, 7, -3.1, 100, 8]
       var data2 = [20, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8, 4.1, 7, -3.1, 10, 8, 4.1, 7, -3.1, 5, 8]
     var data3 = [50,30,22,1, 0,50,20, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8, 4.1, 7]
    //Class
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell=tableView.dequeueReusableCell(withIdentifier: "balanceCell")
          let contentView = cell?.contentView
          let imageArrow=contentView?.viewWithTag(1) as! UIImageView
          let balance=contentView?.viewWithTag(2) as! UILabel
           let amount=contentView?.viewWithTag(3) as! UILabel
          return cell!
          
        }

    @IBOutlet var viewContainer: UIScrollView!
    override func viewDidLoad() {
        initStat()
         super.viewDidLoad()
    }
    
    func initStat()  {
            let size = 50
            viewContainer.showsHorizontalScrollIndicator = true
            viewContainer.contentSize = CGSize(width: data.count*size, height: 220)
            
            let spent = ChartSeries(data)
            spent.color = .red
            let earned = ChartSeries(data2)
            earned.color = .green
            let saving = ChartSeries(data3)
            saving.colors = (
              above: ChartColors.blueColor(),
              below: ChartColors.redColor(),
              zeroLevel: 20
            )
            saving.area = true
            let chart =  Chart(frame: CGRect(x: 0, y: 0, width:data.count*size , height: 220))
            chart.backgroundColor = .white
            chart.add([spent,earned,saving])
            // Use `xLabels` to add more labels, even if empty
            chart.xLabels = [0, 3, 6, 9, 12, 15, 18, 21, 24]
            // Format the labels with a unit
            chart.xLabelsFormatter = { String(Int(round($1))) + "h" }
            viewContainer.addSubview(chart)
            self.view.addSubview(viewContainer)
    }

    
    @IBAction func perDay(_ sender: Any) {
    }
    
    @IBAction func perWeek(_ sender: Any) {
    }
    @IBAction func perMonth(_ sender: Any) {
    }
    @IBAction func perTotal(_ sender: Any) {
    }
    
}

