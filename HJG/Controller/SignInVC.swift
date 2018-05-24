//
//  SignInVC.swift
//  HJG
//
//  Created by Suzy Park on 2018. 5. 24..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInVC: UIViewController {

    var userRef: CollectionReference!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = Firestore.firestore().collection(CollectionName.user.rawValue)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        guard let email = emailTF.text,
            email != "",
            let pwd = pwdTF.text,
            pwd != ""
            else {
                AlertVC.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
            guard error == nil else {
                AlertVC.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard let user = user else { return }
            print(user.user.email ?? "MISSING EMAIL")
            UserDefaults.standard.set(true, forKey: "firebasAccountLogIn")
            UserDefaults.standard.synchronize
            // go to main tab bar
            
        }
    }
    
    @IBAction func createNewAccountBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let signUpNVC = storyboard.instantiateViewController(withIdentifier: "SignUpNVC")
        present(signUpNVC, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension SignInVC : GIDSignInDelegate, GIDSignInUIDelegate {
    
    private func setupSignUp() {
        GIDSignIn.sharedInstance().delegate = self // google
        GIDSignIn.sharedInstance().uiDelegate = self // email
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Have disconnected")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to log into Google: ", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print("log In", user)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("Failed to create a Firebase User with Google account: ", error)
                return
            }
            
            // User is signed in
            guard let uid = user?.user.uid else { return }
            let email = user?.user.email
            let name = user?.user.displayName
            let dataToSave: [String : Any] = ["email" : email ?? "", "name" : name ?? "", "uid" : uid]
            
            self.userRef.document(uid).setData(dataToSave) { (error) in
                if let error = error {
                    print("error:", error)
                } else {
                    print("Data has been saved!")
                }
            }
            
            UserDefaults.standard.set(true, forKey: "googleLogIn")
            UserDefaults.standard.synchronize
            print("Successfully logged into Firebase with Google", uid)
            // go main tab bar
        }
    }
}
