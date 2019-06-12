//
//  GiveBrownieViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/11/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit
import os

class GiveBrownieViewController: UIViewController {

	@IBOutlet weak var brownieNumberLabel: UILabel!
	@IBOutlet weak var pointDescription: UILabel!

	@IBAction func givePoint(_ sender: Any) {

		let points = Int(brownieNumberLabel.text!)! + 1
		brownieNumberLabel.text = String(points)

		if (points == 1) {
			pointDescription.text = "Point"
		} else {
			pointDescription.text = "Points"
		}

//		 @TODO: other callbacks and stuff in here
//		 save locally, etc.
	}

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
