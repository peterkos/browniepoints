//
//  FriendsController.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/21/19.
//  Copyright © 2019 UW. All rights reserved.
//

import Foundation
import RealmSwift

// Attempt at an alternative to the singleton pattern.
// Instead of storing one static state across the application,
// a reference to this state will be passed around as needed.
// The root will be instantiated at the AppDelegate level, and passed from there.

// (using code.tutsplus.com article for reference)

class FriendsController {

	var friends = List<Friend>()

	// Note that reading/writing state here is handled by the AppDelegate.
	// It would probably be smarter to route ALL data management through here,
	// however manually re-building a reactive pattern is probably best done
	// with RxSwift outright.

}
