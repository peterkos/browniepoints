//
//  LoginViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/22/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

	var friendsController: FriendsController!

    override func viewDidLoad() {
        super.viewDidLoad()

		// Configure GIDSignIn
        GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().signIn()

    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("LOGINVC PREPAREFORSEGUE CALLED")

		// Pass our data down another level
		if let navVC = segue.destination as? MainNavigationViewController {
			navVC.friendsController = self.friendsController
		} else {
			print("Unable to pass from login view controller")
		}

	}



}
