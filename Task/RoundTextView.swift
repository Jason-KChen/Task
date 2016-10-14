//
//  RoundTextView.swift
//  Task
//
//  Created by Kun Chen on 10/13/16.
//  Copyright © 2016 Kun Chen. All rights reserved.
//

import UIKit

class RoundTextView: UITextView {

    override func awakeFromNib() {
        layer.cornerRadius = 30
        clipsToBounds = true
    }
    
}
