//
//  ThreeSetting.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 4. 24..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import GoogleSignIn

class ThreeSetting: UITableViewController {
    
    @IBOutlet weak var userAccountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = Auth.auth().currentUser?.email
        if let email = email {
        self.userAccountLbl.text = email
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "확인", style: .destructive) { _ in
                self.userAccountLbl.text = ""
                // 구글 로그아웃
                GIDSignIn.sharedInstance().signOut()
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.performSegue(withIdentifier: "signOutSeg", sender: nil)
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
        }
        alert.addAction(cancel)
        alert.addAction(logOut)
        present(alert, animated: true, completion: nil)
    }
}
