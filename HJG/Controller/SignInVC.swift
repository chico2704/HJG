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

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignUp()
        emailTF.delegate = self
        pwdTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

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
            print(user.user.uid)
            
            UserDefaults.standard.set(true, forKey: "firebasAccountLogIn")
            UserDefaults.standard.synchronize

            let storyboard = UIStoryboard.init(name: "TabBar", bundle: Bundle.main)
            let tabBar = storyboard.instantiateViewController(withIdentifier: "TabBar")
            self.present(tabBar, animated: true, completion: nil) // go to main tabBar
        }
    }
    
    @IBAction func createNewAccountBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let signUpNVC = storyboard.instantiateViewController(withIdentifier: "SignUpNVC")
        present(signUpNVC, animated: true, completion: nil) // go to main tabBar
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
        print("log In: ", user)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("Failed to create a Firebase User with Google account: ", error)
                return
            }
            guard let uid = user?.user.uid else { return }
            UserDefaults.standard.set(true, forKey: "googleLogIn")
            UserDefaults.standard.synchronize
            print("Successfully logged into Firebase with Google: ", uid)

            let storyboard = UIStoryboard.init(name: "TabBar", bundle: Bundle.main)
            let tabBar = storyboard.instantiateViewController(withIdentifier: "TabBar")
            self.present(tabBar, animated: true, completion: nil) // go main tab bar
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
