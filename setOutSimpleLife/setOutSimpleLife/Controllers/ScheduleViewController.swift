//
//  ScheduleViewController.swift
//  setOutSimpleLife
//
//  Created by taha on 06/12/2020.
//

import UIKit
import CalendarKit

class ScheduleViewController: DayViewController {
    var data:[[String]] = []
    var date:Date = Date()
    var schedules:[ScheduleModel] = []
    
    func getAllSchedule()  {
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
                     let result = try JSONDecoder().decode(AllSchedules.self, from: data)
                      let array = result.tasks as [ScheduleModel]?
                    DispatchQueue.main.async {
                        for row in array!{
                            self.data.append([row.taskName,row.note])
                         
                        }
                        self.schedules = array!
                        self.alreadyGeneratedSet.insert(self.date)
                        self.generatedEvents.removeAll()
                        self.generatedEvents.append(contentsOf: self.generateEventsForDate(self.date))
                        self.reloadData()
                    }
                  }catch{
                      print("failed to convert \(error.localizedDescription) ")
                  }
          }.resume()
    }
    
     var generatedEvents = [EventDescriptor]()
     var alreadyGeneratedSet = Set<Date>()
     
     var colors = [UIColor.blue,
                   UIColor.yellow,
                   UIColor.green,
                   UIColor.red]

     private lazy var rangeFormatter: DateIntervalFormatter = {
       let fmt = DateIntervalFormatter()
       fmt.dateStyle = .none
       fmt.timeStyle = .short

       return fmt
     }()

    override func loadView() {
       calendar.timeZone = TimeZone(abbreviation: "GMT")!
       dayView = DayView(calendar: calendar)
       view = dayView
     }
     
     override func viewDidLoad() {
           getAllSchedule()
       super.viewDidLoad()
       navigationController?.navigationBar.isTranslucent = false
       dayView.autoScrollToFirstEvent = true
       reloadData()
     }
     
     // MARK: EventDataSource
 
     override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        
       if !alreadyGeneratedSet.contains(date) {
         alreadyGeneratedSet.insert(date)
        generatedEvents.removeAll()
         generatedEvents.append(contentsOf: generateEventsForDate(date))
        reloadData()
       }
       return generatedEvents
     }
     
     private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
         let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        var events = [Event]()
        var i = 0
        for row in data {
         let event = Event()
            event.startDate = dateformatter.date(from: schedules[i].dateCreation)!
            event.endDate = dateformatter.date(from: schedules[i].endTime)!
         event.text = row.reduce("", {$0 + $1 + "\n"})
            print(event.text)
         event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
         if #available(iOS 12.0, *) {
           if traitCollection.userInterfaceStyle == .dark {
             event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
             event.backgroundColor = event.color.withAlphaComponent(0.6)
           }
         }
         events.append(event)
            i += 1
       }

       return events
     }
     
     private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
       var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
       baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
       return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
     }
     
     // MARK: DayViewDelegate
     
     private var createdEvent: EventDescriptor?
     
     override func dayViewDidSelectEventView(_ eventView: EventView) {
       guard let descriptor = eventView.descriptor as? Event else {
         return
       }
    //   print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
     }
     
     override func dayViewDidLongPressEventView(_ eventView: EventView) {
       guard let descriptor = eventView.descriptor as? Event else {
         return
       }
       endEventEditing()
     // print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
       beginEditing(event: descriptor, animated: true)
       //print(Date())
     }
     
     override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
       endEventEditing()
     //  print("Did Tap at date: \(date)")
     }
     
     override func dayViewDidBeginDragging(dayView: DayView) {
       endEventEditing()
     //  print("DayView did begin dragging")
     }
     
     override func dayView(dayView: DayView, willMoveTo date: Date) {
    //   print("DayView = \(dayView) will move to: \(date)")
     }
     
     override func dayView(dayView: DayView, didMoveTo date: Date) {
      // print("DayView = \(dayView) did move to: \(date)")
     }
     
     override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    //   print("Did long press timeline at date \(date)")
       // Cancel editing current event and start creating a new one
       endEventEditing()
       let event = generateEventNearDate(date)
     //  print("Creating a new event")
       create(event: event, animated: true)
       createdEvent = event
     }
     
     private func generateEventNearDate(_ date: Date) -> EventDescriptor {
        //print("here")
       let duration = Int(arc4random_uniform(160) + 60)
       let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
       let event = Event()
       event.startDate = startDate
       event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: startDate)!
       
       var info = data[Int(arc4random_uniform(UInt32(data.count)))]

       info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
       event.text = info.reduce("", {$0 + $1 + "\n"})
       event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
       event.editedEvent = event
       
       // Event styles are updated independently from CalendarStyle
       // hence the need to specify exact colors in case of Dark style
       if #available(iOS 12.0, *) {
         if traitCollection.userInterfaceStyle == .dark {
           event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
           event.backgroundColor = event.color.withAlphaComponent(0.6)
         }
       }
       return event
     }
     
     override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
       
    //   print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
       
       if let _ = event.editedEvent {
         event.commitEditing()
       }
       
       if let createdEvent = createdEvent {
         createdEvent.editedEvent = nil
         generatedEvents.append(createdEvent)
         self.createdEvent = nil
         endEventEditing()
       }
        
       reloadData()
     }
   }
