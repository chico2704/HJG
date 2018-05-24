//
//  TwoDetailVC.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 5. 2..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit

class TwoDetailVC: UIViewController {
    
    // 데이터 저장 변수
    var param: Goal?
    
    @IBOutlet weak var detailView: UIViewX!
    @IBOutlet weak var hanJulLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    override func viewDidLoad() {
        self.titleLbl.text = param?.title
        self.contentLbl.text = param?.content
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        if let data = param, let date = data.date {
            self.timeLbl.text = formatter.string(from: date)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
