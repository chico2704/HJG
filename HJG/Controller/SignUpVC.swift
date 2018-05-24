//
//  SignUpVC.swift
//  HJG
//
//  Created by Suzy Park on 2018. 5. 24..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
//    var userRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userRef = Firestore.firestore().collection(CollectionName.user.rawValue)
    }

    @IBAction func closedBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpWithNewAccountBtnTapped(_ sender: Any) {
        // check if all TFs have valid text value and unwrap
        guard let name = usernameTF.text,
            name != "",
            let email = emailTF.text,
            email != "",
            let pwd = pwdTF.text,
            pwd != ""
            else {
                AlertVC.showAlert(self, title: "Missing Info", message: "Please fill out all fields")
                return
        }
        
        // unless they are empty, we can move forward
        Auth.auth().createUser(withEmail: email, password: pwd) { (user, error) in
            guard error == nil else {
                AlertVC.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            
//            guard let user = user else { return }
//            let dataToSave: [String : Any] = ["email" : email, "pwd" : pwd, "name" : name, "uid" : user.user.uid]
//            self.userRef.document(user.user.uid).setData(dataToSave) { (error) in
//                if let error = error {
//                    print("error:", error)
//                } else {
//                    print("Data has been saved!")
//                }
//            }
        }
        // go main tab bar
    }
}
