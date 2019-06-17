//
//  BrowniePointButton.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/17/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit

class BrowniePointButton: UIButton {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)

		// Configure some properties of this special button
		// which don't appear to work all the time haha
		// (literally just corner radius)
		self.layer.masksToBounds = true
		self.layer.cornerRadius = 5.0

    }

}
