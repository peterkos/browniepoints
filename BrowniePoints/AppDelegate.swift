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


		// pass in the stupid model cotnroller
		if let navVC = self.window?.rootViewController as? MainNavigationViewController {
			navVC.friendsController = self.friendsController
		}

		// Now to conditionally show the view based on user authentication.
		let storyboard = self.window?.rootViewController?.storyboard

		// Set normal screen if logged in
		if (loggedIn!) {

			print("User is logged in!")

			DispatchQueue.main.async {
				self.reassignMainVC()
			}


		} else {

			print("User is NOT logged in!")

			// Otherwise, show the login/splash screen and move on
//			self.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController")


			// Instantiate loginVC and pass model controller
			let loginVCInstantiated = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController

			guard let loginVC = loginVCInstantiated else {
				print("Unable to instantiate loginVC")
				fatalError()
			}

			loginVC.friendsController = self.friendsController

			// Show it!
			let rootVC = self.window?.rootViewController
			rootVC?.present(loginVC, animated: true, completion: nil)

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

			print("User is signed in!")

			// Login persistence
//			UserDefaults.standard.set(true, forKey: "isLoggedIn")

			// Let's try this on the main thread
			DispatchQueue.main.async {

//				let rootVC = self.window?.rootViewController

//				rootVC = self.

				// Now that our view controller is instantiated, go!
//				self.window?.rootViewController?.performSegue(withIdentifier: "loginSuccessSegue",
//															  sender: self.friendsController)

			}



		}

	}

	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		print("LOGGED OUT")
	}



	// A function that instantiates the initial view controller and passes the model controller forward.
	// I've factored this out to its own method mainly because of the model controller,
	// and both the initial login flow and the GIDSignInDelegate signIn(...) need to do this step.
	func reassignMainVC() {

		var rootVC = self.window?.rootViewController

		// Re-assign our root view controller to the mainNavViewController (containing GiveBrownieViewController)
		rootVC = rootVC?.storyboard?.instantiateInitialViewController()


//		// Pass a reference of our model controller to our initial view controller
//		// (traversing navVC -> tabBarVC -> GiveBrowieVC)
//		if let giveBrownieViewController = initialVC?.children.first?.children.first as? GiveBrownieViewController {
//			print("from AppDel: \(friendsController)")
//			giveBrownieViewController.friendsController = friendsController
//			giveBrownieViewController.testVar = 10
//			print("sent instance")
//			return giveBrownieViewController
//		} else {
//			print("Unable to find GiveBrownieViewController.")
//			return nil
//		}

	}

}

