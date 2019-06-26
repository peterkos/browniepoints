//
//  BrowseFriendsViewController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/11/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit
import os
import RealmSwift

class BrowseFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var friendsTable: UITableView!


	// MARK: Local Variables
	// Data source for friends
	var friendsController: FriendsController! {
		didSet {

			// Only reload if view is available
			if friendsTable != nil {
				self.friendsTable.reloadData()
			}

		}
	}

	// Oh realm
	let realm = try! Realm()


	// MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Set nav bar title
		if let parentVC = super.parent {
			parentVC.title = "Find Friends"
		}

		// Configure the table view to point to US
		friendsTable.delegate = self
		friendsTable.dataSource = self

    }


	// MARK: -- UITableViewDelegate/DataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friendsController.friends.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell")!

		// Setup the cell with some data
		friendCell.textLabel!.text = friendsController.friends[indexPath.row].username
		friendCell.detailTextLabel!.text = friendsController.friends[indexPath.row].browniePoints.description

		return friendCell

	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let title = "Become friends with \(friendsController.friends[indexPath.row].username)?"
		let alertView = UIAlertController(title: title, message: nil, preferredStyle: .alert)

		// Add some buttonz
		// @TODO: Connect this to update model (database) state
		alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { cancelAction in
			print("cancelled")
			alertView.dismiss(animated: true, completion: nil)
		}))

		alertView.addAction(UIAlertAction(title: "Join the pan", style: .default, handler: { acceptAction in
			print("accepted!")
			alertView.dismiss(animated: true, completion: nil)
		}))

		self.present(alertView, animated: true)

	}

	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

		// Manually trigger the segue, passing through the index of the tapped friend
		// (Note that the segue is defined in the storyboard between the current VC, and the destination VC.)
		performSegue(withIdentifier: "showFriendProfileSegue", sender: indexPath.row)
		
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


		// @TODO: Setup custom card-style popover transition. Or, somehow modify the current modal one
		if segue.identifier == "showFriendProfileSegue" {

			guard let friendProfileViewController = segue.destination as? FriendProfileViewController else {
				os_log("Unable to instantiate destination friend view controller in showFriendProfileSegue.")
				return
			}

			guard let friendIndex = sender as? Int else {
				os_log("Sender segue data is wrong type, for showFriendProfileSegue")
				return
			}

			friendProfileViewController.currentFriend = friendsController.friends[friendIndex]
		}
	}


}
