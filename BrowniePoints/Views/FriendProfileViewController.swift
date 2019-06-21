//
//  FriendProfileViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/20/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {

	@IBOutlet weak var friendNameLabel: UILabel!


	var currentFriend: Friend?


    override func viewDidLoad() {
        super.viewDidLoad()

		if currentFriend != nil {
			print("current friend not nil!")
			friendNameLabel.text = currentFriend!.username
		}


		
		// @TODO: Setup detail view with card-style popover of a profile, with rounded profile image and things


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
