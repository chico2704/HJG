//
//  AlertVC.swift
//  HJG
//
//  Created by Suzy Park on 2018. 5. 25..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit

class AlertVC {
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
