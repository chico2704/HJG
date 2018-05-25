//
//  OneDesk.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 4. 24..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class OneDesk: UIViewController {
    
    @IBOutlet weak var goalLbl: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var floatingExpandingView: UIViewX!
    @IBOutlet weak var floatingActionButton: FloatingActionButton!
    
    let userDefaults = UserDefaults.standard
    var goalRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneInitialViewSetting()
        goalLbl.text = userDefaults.string(forKey: "labelState")
        goalRef = Database.database().reference()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetFloatingActionButton()
        closeFloatingExpanding()
        goalLbl.text = userDefaults.string(forKey: "labelState")
    }
}

// MARK:- Button Action
extension OneDesk {
    
    @IBAction func basicButtons(_ sender: UIButton) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        switch sender.tag {
        case 1:
            if goalLbl.text == "" || goalLbl.text == nil {
                alertVC.title = "목표입력"
                alertVC.message = "오늘 하루 가장 중요한 나의 목표는"
                alertVC.addTextField { (UITextField) in
                    UITextField.placeholder = "10자 이내로 입력하세요"
                }
                let add = UIAlertAction(title: "확인", style: .default) { _ in
                let textField = alertVC.textFields![0]
                    if textField.text != "" {
                        self.goalLbl.text = textField.text
                        self.userDefaults.set(self.goalLbl.text, forKey: "labelState")
                        self.closeFloatingExpanding()
                        self.resetFloatingActionButton()
                    }
                }
                alertVC.addAction(add)
            } else if goalLbl.text != "" {
                alertVC.title = "목표입력"
                alertVC.message = "이미 등록된 목표가 있습니다"
            }
        case 2:
            if goalLbl.text == "" || goalLbl.text == nil {
                alertVC.title = "목표삭제"
                alertVC.message = "삭제할 목표가 없습니다"
            } else if goalLbl.text != "" {
                alertVC.title = "목표삭제"
                alertVC.message = "등록된 목표를 삭제하시겠습니까?"
                let add = UIAlertAction(title: "확인", style: .destructive) { _ in
                    self.goalLbl.text = ""
                    self.userDefaults.set(self.goalLbl.text, forKey: "labelState")
                    self.closeFloatingExpanding()
                    self.resetFloatingActionButton()
                }
                alertVC.addAction(add)
            }
        case 3:
            if self.goalLbl.text == "" || goalLbl.text == nil {
                alertVC.title = "목표등록"
                alertVC.message = "등록된 목표가 없습니다"
                } else if self.goalLbl.text != "" {
                    alertVC.title = "목표등록"
                    alertVC.message = "오늘 달성한 목표에 대한 코멘트를 적어주세요"
                    alertVC.addTextField { (UITextField) in
                        UITextField.placeholder = "목표를 달성하셨군요? 대단해요!"
                    }
                    let add = UIAlertAction(title: "확인", style: .default) { _ in
                        let textField = alertVC.textFields![0]
                        if self.goalLbl.text != "" {
                            
                            let date = String(describing: Date())
                            
                            if let uid = Auth.auth().currentUser?.uid,
                                let title = self.goalLbl.text,
                                let content = textField.text {

                                    let dataToSave: [String : Any] = [ "title"      : title ,
                                                                       "content"    : content,
                                                                       "date"       : date ]
                                    self.goalRef.child(uid).childByAutoId().setValue(dataToSave)
                            }
                            // goalLbl 초기화 및 유저디폴트 기억
                            self.goalLbl.text = ""
                            self.userDefaults.set(self.goalLbl.text, forKey: "labelState")
                            self.closeFloatingExpanding()
                            self.resetFloatingActionButton()
                            
                            self.tabBarController?.selectedIndex = 1 // 탭2로 이동
                        }
                    }
                    alertVC.addAction(add)
                }
        default: ()
        }
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK:- Initial View Setting
extension OneDesk {
    
    func oneInitialViewSetting() {
        setupGoalLbl()
        closeFloatingExpanding()
    }
    
    func setupGoalLbl() {
        goalLbl.font = UIFont(name: "Sandoll MiSaeng", size: 40)
        goalLbl.textColor = UIColor.darkGray
        goalLbl.textAlignment = .center
    }
    
    func resetFloatingActionButton(){
        UIView.animate(withDuration: 0.3, animations: {
            self.floatingActionButton.transform = .identity
            self.floatingActionButton.backgroundColor = #colorLiteral(red: 0.7569, green: 0.7412, blue: 0.7373, alpha: 1)
        })
    }
}

// MARK:- Floating Action Button and Animation
extension OneDesk {
    
    func closeFloatingExpanding() {
        floatingExpandingView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        writeButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        resetButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        doneButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    @IBAction func floatingButtonRotationAction(_ sender: FloatingActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.floatingExpandingView.transform == .identity {
                self.closeFloatingExpanding()
            } else {
                self.floatingExpandingView.transform = .identity
            }
        })
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            if self.floatingExpandingView.transform == .identity {
                self.writeButton.transform = .identity
                self.resetButton.transform = .identity
                self.doneButton.transform = .identity
            }
        })
    }
}
