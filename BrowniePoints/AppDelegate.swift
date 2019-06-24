//
//  AppDelegate.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/10/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?
	var friendsController = FriendsController()


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


		// Firebase
		FirebaseApp.configure()

		// Google Sign-in
		GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance()?.delegate = self


		// Realm setup & data

		let realm = try! Realm()

		// @TODO: Add logic to filter only actual friends
		let allFriends = realm.objects(Friend.self)

		if (!allFriends.isEmpty) {

			// Read the data into our local model isntance for our friendCollectionView
			friendsController.friends.append(objectsIn: allFriends)

		} else {

			// If no friends (someting something no cookies), add friends!
			// (If only it was like this irl 😭)
			friendsController.friends.append(Friend(username: "Dave", browniePoints: 2))
			friendsController.friends.append(Friend(username: "Joe", browniePoints: 5))
			friendsController.friends.append(Friend(username: "Bob", browniePoints: 0))
			friendsController.friends.append(Friend(username: "Katie", browniePoints: 10))

			// Save this example data to Realm, if it doesn't alreay exist
			// (handled automatically by Realm)
			try! realm.write {
				realm.add(friendsController.friends, update: .all)
			}
		}

		// Finally, pass a reference of our model controller to our initial view controller
		if let giveBrownieViewController = window?.rootViewController?.children.first?.children.first as? GiveBrownieViewController {
			giveBrownieViewController.friendsController = friendsController
			print("sent instance")
		} else {
			print("Unable to find root view controller.")
			// this isnt our initial VC at the moment so let's not get ahead of ourselves and QUIT
//			fatalError()
		}


		return true
	}


	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		return (GIDSignIn.sharedInstance()?.handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: [:]))!
	}


	// MARK: GIDSignInDelegate
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {
			print(error.localizedDescription)
			return
		}

		// From API documentation... however, it's an implicitly unwrapped optional??
		guard let authentication = user.authentication else {
			print("Unable to instantiate user auth")
			return
		}

		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
													   accessToken: authentication.accessToken)

		Auth.auth().signIn(with: credential) { (authDataResult, error) in

			// @TODO: Show sign in error to user
			if let error = error {
				print(error)
				return
			}

			// User is signed in!
			// @TODO: Do stuff


			print("User is signed in!")

			// If we are in our login view controller,segue to the main view controller.
			// Otherwise, uh... figure something out.
			if let loginVC = self.window?.rootViewController as? LoginViewController {

				let storyboard = self.window?.rootViewController?.storyboard
				let mainNavVCNew = storyboard?.instantiateViewController(withIdentifier: "mainNavViewController")

				guard let mainNavVC = mainNavVCNew else {
					print("Unable to find mainNavViewController")
					fatalError()
				}

				// Pass a reference of our model controller to our initial view controller
				if let giveBrownieViewController = mainNavVC.children.first?.children.first as? GiveBrownieViewController {
					giveBrownieViewController.friendsController = self.friendsController
					print("sent instance 1")
				} else {
					print("Unable to find root view controller in sign in flow 1.")
				}

				if let another = mainNavVC.children.first?.children.last as? BrowseFriendsViewController  {
					print("sent instance 2")
					another.friendsController = self.friendsController
				} else {
					print("Unable to find root view controller in sign in flow 2.")
				}

				// Login persistence
				UserDefaults.standard.set(true, forKey: "Logged in")

				// Now that our view controller is instantiated, go!
				loginVC.performSegue(withIdentifier: "loginSuccessSegue", sender: nil)
			}


		}

	}

	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		// @TODO: On disconnect, do things
	}


}

