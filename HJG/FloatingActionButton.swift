//
//  FloatingActionButton.swift
//  HanJul
//
//  Created by Suzy Park on 2018. 4. 25..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//
import Foundation
import UIKit

class FloatingActionButton: UIButtonX {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity {
                // open
                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
                self.backgroundColor = #colorLiteral(red: 0.5882, green: 0.5804, blue: 0.5765, alpha: 1)
            } else {
                // close
                self.transform = .identity
                self.backgroundColor = #colorLiteral(red: 0.7569, green: 0.7412, blue: 0.7373, alpha: 1)
            }
        })
        return super.beginTracking(touch, with: event)
    }
}
