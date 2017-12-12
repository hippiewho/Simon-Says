//
//  CircularButton.swift
//  Simon Says
//
//  Created by Frank Navarrete on 12/10/17.
//  Copyright © 2017 TheHippieHop. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }

    override  var isHighlighted: Bool {
        didSet  {
            if isHighlighted {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
}
