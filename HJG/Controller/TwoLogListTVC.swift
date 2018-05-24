//
//  TwoLogListTableViewController.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 5. 8..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit

class TwoLogListTableViewController: UITableViewController {
    
    var goalList = [Goal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.goalList.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // goalList 배열 데이터에서 주어진 행에 맞는 데이터 꺼내기
        let row = self.goalList[indexPath.row]
        // 재사용 큐로부터 프로토타입 셀 인스턴스 전달받기
        let cell = tableView.dequeueReusableCell(withIdentifier: "logListCell") as? TwoLogListCell
        // logCell 구현
        cell?.titleLbl.text = row.title
        cell?.contentLbl.text = row.content
        cell?.indexLbl.text = "#" + String(tableView.numberOfRows(inSection: 0) - indexPath.row)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        cell?.dateLbl.text = timeFormatter.string(from: row.date)
        cell?.titleLbl.numberOfLines = 0
        cell?.contentLbl.numberOfLines = 0
        // Date 타입의 날짜를 포맷에 맞게 변경
        return cell!
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.goalList[indexPath.row]
        if editingStyle == .delete {
                self.goalList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
