//
//  ViewController.swift
//  diary
//
//  Created by Glip on 28.02.2021.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    let hours: [String] = ["00.00 - 01.00", "01.00 - 02.00", "02.00 - 03.00", "03.00 - 04.00", "04.00 - 05.00", "05.00 - 06.00", "06.00 - 07.00", "07.00 - 08.00", "08.00 - 09.00", "09.00 - 10.00", "10.00 - 11.00", "11.00 - 12.00", "12.00 - 13.00", "13.00 - 14.00", "14.00 - 15.00", "15.00 - 16.00", "16.00 - 17.00", "17.00 - 18.00", "18.00 - 19.00", "19.00 - 20.00", "20.00 - 21.00", "21.00 - 22.00", "22.00 - 23.00", "23.00 - 24.00"]
    var events = Array<Events>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollToDate(Date())
        setupCalendarView()
    }

    func setupCalendarView() {
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
            guard let validCell = view as? dateCell else { return }
    
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLable.textColor = .black
            } else {
                validCell.dateLable.textColor = .gray
            }
    }

}

extension ViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension ViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! dateCell
        cell.dateLable.text = cellState.text
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! dateCell
        cell.dateLable.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func getServerEvents() {
        let url = URL(string: "https://diarybamcom-default-rtdb.firebaseio.com/")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonValues = try! JSONSerialization.jsonObject(with: data!) as! Array<Any>
            self.events = self.mapping(jsonValues: jsonValues)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
        }
        task.resume()
        
    }
    
    
    
    func mapping(jsonValues: Array<Any>) -> [Events] {
        var resultArray = Array<Events>()
        
        for element in jsonValues {
            let events = Events(json: element as! Dictionary<String, Any>)
            resultArray.append(events)
        }
        
        return resultArray
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableView", for: indexPath)
        cell.textLabel?.text = hours[indexPath.row]

        return cell
    }
    
}

