//
//  FriendProfileViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/20/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var pointLabel: UILabel!


	// MARK: Local variables
	var currentFriend: Friend?


	// MARK: View functions

    override func viewDidLoad() {
        super.viewDidLoad()

		// Return if the friend wasn't passed properly from the BrowseFriendsViewController
		guard let friend = currentFriend else {
			print("Unable to instantiate friend profile (no friend object found).")
			return
		}

		// Configure the image view
		profileImageView.layer.cornerRadius = CGFloat(5.0)

		// Fill the properties!
		nameLabel.text = friend.username
		pointLabel.text = friend.browniePoints.description + " points"
//		profileImageView.image = friend.profileImaage



		// @TODO: Setup detail view with card-style popover of a profile, with rounded profile image and things


    }

}
