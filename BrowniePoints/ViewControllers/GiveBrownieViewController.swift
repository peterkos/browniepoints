//
//  GiveBrownieViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/11/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit
import os

import CenteredCollectionView
import RealmSwift
import GoogleSignIn

class GiveBrownieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var brownieNumberLabel: UILabel!
	@IBOutlet weak var pointDescription: UILabel!
	@IBOutlet weak var friendCollection: UICollectionView!
	
	@IBAction func givePoint(_ sender: BrowniePointButton) {

		guard currentFriend != nil else {
			print("Unable to find current friend.")
			return
		}

		// Update the model
		do {
			try realm.write {

				// (Add might not be nessecary?)
				currentFriend!.browniePoints += 1
				realm.add(currentFriend!)

				print("Updated \(currentFriend!.username) to \(currentFriend!.browniePoints) points!")
			}
		} catch let error as NSError {
			print(error.debugDescription)
			return
		}

		// Update the view
		brownieNumberLabel.text = String(currentFriend!.browniePoints)

		// Update point description singular vs. plural
		// @TODO: Move this so it gets updated when currentFriend is selected, or better yet, database is updated
		// As it stands, if database is updated, this doesn't change.
		if currentFriend!.browniePoints == 1 {
			pointDescription.text = "Point"
		} else {
			pointDescription.text = "Points"
		}
	}

	@IBAction func logout(_ sender: Any) {
		GIDSignIn.sharedInstance().signOut()

	}

	// MARK: Local variables

	// Local variables for friend collection view
	let cellPercentWidth = CGFloat(0.7)
	var friendViewFlowLayout: CenteredCollectionViewFlowLayout!

	// Model state
	var friendsController: FriendsController!

	// Reference to the current friend
	var currentFriend: Friend? {
		didSet {
			brownieNumberLabel.text = String(currentFriend!.browniePoints)
			print("Current friend is now: \(currentFriend!.username)")
		}
	}

	// Oh realm
	let realm = try! Realm()


	// MARK: View functions

	override func viewDidLoad() {
        super.viewDidLoad()

		// Configure friend collection view data
		friendViewFlowLayout = friendCollection.collectionViewLayout as? CenteredCollectionViewFlowLayout
		friendCollection.decelerationRate = .fast
		friendCollection.delegate = self
		friendCollection.dataSource = self

		// Configure friend collection view, view.
		friendViewFlowLayout.itemSize = CGSize(width: view.bounds.width * cellPercentWidth,
											   height:  CGFloat(100.0))

		// Set to vertical scroll, and remove scrollbars
		friendViewFlowLayout.scrollDirection = .vertical
		friendCollection.showsVerticalScrollIndicator = false
		friendCollection.showsHorizontalScrollIndicator = false

		// Set background color for now
		friendCollection.backgroundView?.backgroundColor = .white

		// In addition to setting the current friend when the friend collection view is done scrolling,
		// on initial viewdidload, no scrolling has occured.
		// So, when the user loads up the page, we need to set it ourselves manually.
		// (Defaults to first friend if it cannot be instantiated)
		currentFriend = friendsController.friends[friendViewFlowLayout.currentCenteredPage ?? 0]

    }

	override func viewWillDisappear(_ animated: Bool) {

		// When navigating away, pass our model controller to the next available view
		// (here, only BrowseFriendsViewController)
		if let browseFriendsViewController = self.tabBarController?.viewControllers?[1] as? BrowseFriendsViewController {
			browseFriendsViewController.friendsController = friendsController
			print("sent instance")
		} else {
			print("Unable to find next view controller.")
			fatalError()
		}
	}

	// MARK: -- UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return friendsController.friends.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? FriendCollectionViewCell

		// This might not be nessecary...
		guard let friendCell = cell else {
			os_log("Unable to instantiate friend cell at index %d", indexPath.row)
			fatalError()
		}

		// @TODO: Hanadle database updates automatically
		// If the database is updated now, the UI doesn't change until the user swipes around a bit.
		friendCell.label.text = friendsController.friends[indexPath.row].username
		return friendCell
	}

	// Set the current friend once the collection view is done scrolling
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

		guard let friendIndex = friendViewFlowLayout.currentCenteredPage else {
			os_log("Unable to get index of current page in friends")
			return
		}

		currentFriend = friendsController.friends[friendIndex]
	}

}
