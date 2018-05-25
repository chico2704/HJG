//
//  ThreeSetting.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 4. 24..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

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
    }
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "확인", style: .destructive) { _ in
                self.userAccountLbl.text = ""

                GIDSignIn.sharedInstance().signOut()
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                    let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
                    self.present(signInVC, animated: true, completion: nil)
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
        }
        alert.addAction(cancel)
        alert.addAction(logOut)
        present(alert, animated: true, completion: nil)
    }
}
