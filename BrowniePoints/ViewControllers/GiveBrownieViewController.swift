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

class GiveBrownieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var brownieNumberLabel: UILabel!
	@IBOutlet weak var pointDescription: UILabel!
	@IBOutlet weak var friendCollection: UICollectionView!
	
	@IBAction func givePoint(_ sender: BrowniePointButton) {

		guard currentFriend != nil else {
			print("Unable to find current friend.")
			return
		}

		currentFriend!.browniePoints += 1
		brownieNumberLabel.text = String(currentFriend!.browniePoints)

		// Update point description singular vs. plural
		// (back to the old code, I see...)
		if currentFriend!.browniePoints == 1 {
			pointDescription.text = "Point"
		} else {
			pointDescription.text = "Points"
		}

//		 @TODO: other callbacks and stuff in here, persistence, etc.
	}


	// MARK: Local variables

	// Local variables for friend collection view
	let cellPercentWidth = CGFloat(0.7)
	var friendViewFlowLayout: CenteredCollectionViewFlowLayout!

	// Data source for friends, and supporting info
	// @TODO: Make this persistant
	var friends = [Friend]()
	var currentFriend: Friend? {
		didSet {
			brownieNumberLabel.text = String(currentFriend!.browniePoints)
			print("Current friend is now: \(currentFriend!.username)")
		}
	}


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

		// Add some friends!
		friends.append(Friend(username: "dave", browniePoints: 2))
		friends.append(Friend(username: "joe", browniePoints: 5))
		friends.append(Friend(username: "bob", browniePoints: 0))
		friends.append(Friend(username: "katie", browniePoints: 10))


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
