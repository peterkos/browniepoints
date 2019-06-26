//
//  MainNavigationViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/25/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

	var friendsController: FriendsController!

    override func viewDidLoad() {
        super.viewDidLoad()

		guard let tabVC = self.children.first as? UITabBarController else {
			print("Unable to instantiate child tab bar controller from MainNavVC")
			return
		}

		if let giveVC = tabVC.children.first as? GiveBrownieViewController {
			giveVC.friendsController = self.friendsController
		} else {
			print("Unable to pass data to giveVC")
			fatalError()
		}

		if let browseVC = tabVC.children.last as? BrowseFriendsViewController {
			browseVC.friendsController = self.friendsController
		} else {
			print("Unable to pass data to browseVC")
			fatalError()
		}

    }


	/*
	print("NAV PREPAREFORSEGUE CALLED")

	guard let tabVC = segue.destination as? UITabBarController else {
	print("Unable to instantiate child tab bar controller from MainNavVC")
	return
	}

	if let giveVC = tabVC.children.first as? GiveBrownieViewController {
	giveVC.friendsController = self.friendsController
	}

	if let browseVC = tabVC.children.last as? BrowseFriendsViewController {
	browseVC.friendsController = self.friendsController
	}
	*/

}
