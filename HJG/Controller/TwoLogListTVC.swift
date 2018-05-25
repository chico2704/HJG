//
//  TwoLogListTVC.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 5. 8..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TwoLogListTVC: UITableViewController {
    
    var goals = [Goal]()
    
    var goalRef: DatabaseReference!
    let uid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalRef = Database.database().reference()
        
        if let uid = uid {
            goalRef.child(uid).queryOrdered(byChild: "date").observe(DataEventType.value) { (snapshot) in
            
                self.goals = []
            
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let goalDict = snap.value as? [String : Any] {
                            let goal = Goal(postID: snap.key, dic: goalDict)
                         self.goals.insert(goal, at: 0)
                        }
                    }
                }
                print(self.goals)
                self.tableView.reloadData()
            }
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.goals.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.goals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "logListCell") as? TwoLogListCell

        cell?.titleLbl.text = row.title
        cell?.contentLbl.text = row.content
        cell?.indexLbl.text = "#" + String(tableView.numberOfRows(inSection: 0) - indexPath.row)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        cell?.dateLbl.text = timeFormatter.string(from: row.date)
        cell?.titleLbl.numberOfLines = 0
        cell?.contentLbl.numberOfLines = 0
        return cell!
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.goals[indexPath.row]
        if let uid = uid {
            let dataID = goalRef.child(uid).child(data.postID)
            if editingStyle == .delete {
                self.goals.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                dataID.removeValue()
                self.tableView.reloadData()
            }
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
