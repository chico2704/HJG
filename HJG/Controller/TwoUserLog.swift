//
//  TwoUserLog.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 4. 24..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//
import Foundation
import UIKit
import FSCalendar

class TwoUserLog: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarYear: UILabel!
    @IBOutlet weak var calendarMonth: UILabel!
    @IBOutlet weak var goalListBtn: UIButton!
    @IBOutlet weak var calendarBackgroundView: UIViewX!
    @IBOutlet weak var calendarHeightConst: NSLayoutConstraint!
    
    var dataArray = [Goal]()

    fileprivate lazy var yearFormatter: DateFormatter = {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter
    }()
    
    fileprivate lazy var monthFormatter: DateFormatter = {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        return monthFormatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        self.calendar.select(Date())
        showTodayGoal()
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.tableView.backgroundColor = #colorLiteral(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        self.calendar.clipsToBounds = true // remove border of calendar
        self.calendarYear.text = self.yearFormatter.string(from: calendar.currentPage)
        self.calendarMonth.text = self.monthFormatter.string(from: calendar.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 데이터 가져오기
        self.calendar.select(Date())
        showTodayGoal()
        self.tableView.reloadData()
        self.calendar.reloadData()
    }
    
    func showTodayGoal() {
        self.dataArray = []
        // 데이터 가져오기
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        for i in self.dataArray {
            guard let dates = i.date else { return }
            let strDates = formatter.string(from: dates)
            if strDates == today {
                self.dataArray.append(i)
            } else {}
        }
        self.tableView.reloadData()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popupSeg" {
            if let vc = segue.destination as? TwoDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                vc.param = self.dataArray[indexPath.row]
                
            }
        }
    }
}

// MARK:- Table View
extension TwoUserLog: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = self.appDelegate.goalList.count
        let count = self.dataArray.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 배열 데이터에서 주어진 행에 맞는 데이터 꺼내기
        let row = self.dataArray[indexPath.row]
        // 재사용 큐로부터 프로토타입 셀 인스턴스 전달받기
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as? TwoTableViewCell
        // logCell 구현
        cell?.titleLbl.text = row.title
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        cell?.timeLbl.text = timeFormatter.string(from: row.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        cell?.dateLbl.text = dateFormatter.string(from: row.date)
        let monthFormatter = DateFormatter()
        // "LLLL" = 월이름 풀네임
        monthFormatter.dateFormat = "LLL"
        cell?.monthLbl.text = monthFormatter.string(from: row.date)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.dataArray[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoalRead") as? TwoDetailViewController {
        vc.param = row
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let data = self.dataArray[indexPath.row]
            self.dataArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        self.calendar.reloadData()
    }
}

// MARK:- Calendar
extension TwoUserLog: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConst.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.calendarYear.text = self.yearFormatter.string(from: calendar.currentPage)
        self.calendarMonth.text = self.monthFormatter.string(from: calendar.currentPage)
    }
    
    // event marker
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        for i in self.dataArray {
            guard let dates = i.date else { return 0 }
            let strDates = formatter.string(from: dates)
            if strDates == dateString {
                return 1
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dataArray = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: date)
        for i in self.dataArray {
            guard let dates = i.date else { return }
            let strDates = formatter.string(from: dates)
            if strDates == selectedDate {
                self.dataArray.append(i)
            } else {}
        }
        self.tableView.reloadData()
    }
}
