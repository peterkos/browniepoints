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

    override func viewDidLoad() {
        super.viewDidLoad()

		// Configure GIDSignIn
        GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().signIn()



    }


}
