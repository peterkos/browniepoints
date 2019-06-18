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
		if currentFriend!.browniePoints == 1 {
			pointDescription.text = "Point"
		} else {
			pointDescription.text = "Points"
		}
	}


	// MARK: Local variables

	// Local variables for friend collection view
	let cellPercentWidth = CGFloat(0.7)
	var friendViewFlowLayout: CenteredCollectionViewFlowLayout!

	// Data source for friends, and supporting info
	var friends = List<Friend>()

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

		// @TODO: Add logic to filter only actual friends
		let allFriends = realm.objects(Friend.self)

		if (!allFriends.isEmpty) {

			// Read the data into our local model isntance for our friendCollectionView
			friends.append(objectsIn: allFriends)

			// Also, update
			self.friendCollection.reloadData()
		} else {

			// If no friends (someting something no cookies), add friends!
			// (If only it was like this irl 😭)
			friends.append(Friend(username: "dave", browniePoints: 2))
			friends.append(Friend(username: "joe", browniePoints: 5))
			friends.append(Friend(username: "bob", browniePoints: 0))
			friends.append(Friend(username: "katie", browniePoints: 10))

			// Save this example data to Realm, if it doesn't alreay exist
			// (handled automatically by Realm)
			try! realm.write {
				realm.add(friends, update: .all)
			}
		}

		// In addition to setting the current friend when the friend collection view is done scrolling,
		// on initial viewdidload, no scrolling has occured.
		// So, when the user loads up the page, we need to set it ourselves manually.
		// (Defaults to first friend if it cannot be instantiated)
		currentFriend = friends[friendViewFlowLayout.currentCenteredPage ?? 0]
    }


	// MARK: -- UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return friends.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? FriendCollectionViewCell

		guard let friendCell = cell else {
			os_log("Unable to instantiate friend cell at index %d", indexPath.row)
			fatalError()
		}

		friendCell.label.text = friends[indexPath.row].username
		return friendCell
	}

	// Set the current friend once the collection view is done scrolling
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

		guard let friendIndex = friendViewFlowLayout.currentCenteredPage else {
			os_log("Unable to get index of current page in friends")
			return
		}

		currentFriend = friends[friendIndex]
	}

}
