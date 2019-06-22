//
//  AppDelegate.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/10/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


		// Realm setup & data

		let realm = try! Realm()

		// @TODO: Add logic to filter only actual friends
		let friendsController = FriendsController()
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
			fatalError()
		}


		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

