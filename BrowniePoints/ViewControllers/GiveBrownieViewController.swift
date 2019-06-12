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
	
	@IBAction func givePoint(_ sender: Any) {

		let points = Int(brownieNumberLabel.text!)! + 1
		brownieNumberLabel.text = String(points)

		if (points == 1) {
			pointDescription.text = "Point"
		} else {
			pointDescription.text = "Points"
		}

//		 @TODO: other callbacks and stuff in here
//		 save locally, etc.
	}

	// Local variables for friend collection view
	let cellPercentWidth = CGFloat(0.7)
	var friendViewFlowLayout: CenteredCollectionViewFlowLayout!

	// Data source for friends
	// @TODO: Make this persistant
	var friends = [Friend]()

	override func viewDidLoad() {
        super.viewDidLoad()

		// Configure friend collection view data
		friendViewFlowLayout = friendCollection.collectionViewLayout as? CenteredCollectionViewFlowLayout
		friendCollection.decelerationRate = .fast
		friendCollection.delegate = self
		friendCollection.dataSource = self

		// Configure friend collection view, view.
		friendViewFlowLayout.itemSize = CGSize(width: view.bounds.width * cellPercentWidth,
														   height: view.bounds.height * (cellPercentWidth))
		friendCollection.showsVerticalScrollIndicator = false
		friendCollection.showsHorizontalScrollIndicator = false

		friendCollection.backgroundView?.backgroundColor = .white

		// Add some friends!
		friends.append(Friend(username: "dave", browniePoints: 2))
		friends.append(Friend(username: "joe", browniePoints: 5))
		friends.append(Friend(username: "bob", browniePoints: 0))
		friends.append(Friend(username: "katie", browniePoints: 10))

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

}
