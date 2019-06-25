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


		// Let's check to see if the user is logged in.
		var loggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool

		if loggedIn == nil {
			// If no login state, assume the user is not logged in
			UserDefaults.standard.set(false, forKey: "isLoggedIn")
			loggedIn = false
		}

		// Now to conditionally show the view based on user authentication.
		let storyboard = self.window?.rootViewController?.storyboard

		// Set normal screen if logged in
		if (loggedIn!) {

			print("User is logged in!")
			var rootVC = self.window?.rootViewController

			rootVC = storyboard?.instantiateInitialViewController()

			// Additionally, pass a reference of our model controller to our initial view controller
			// (traversing navVC -> tabBarVC -> GiveBrowieVC)
			if let giveBrownieViewController = rootVC?.children.first?.children.first as? GiveBrownieViewController {
				giveBrownieViewController.friendsController = friendsController
				print("sent instance")
			} else {
				print("Unable to find GiveBrownieViewController.")
			}

		} else {

			print("User is NOT logged in!")

			// Otherwise, show the login/splash screen and move on
			self.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController")

			// @FIXME: Pass data thorugh loginViewController
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

			// Login persistence
			UserDefaults.standard.set(true, forKey: "Logged in")


			// @FIXME: Instantiate next VC
			// Now that our view controller is instantiated, go!
//			loginVC.performSegue(withIdentifier: "loginSuccessSegue", sender: nil)


		}

	}

	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		// @TODO: On disconnect, do things
	}


}

