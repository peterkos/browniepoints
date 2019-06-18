//
//  Friend.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/11/19.
//  Copyright © 2019 UW. All rights reserved.
//

import Foundation
import RealmSwift

class Friend: Object {
	@objc var username: String = ""
	@objc var browniePoints: Int = 0

	// @TODO: Fix instantiating new UUIDs on every launch
//	@objc var id: String = "" // Grr, Realm doesn't support UUID

	convenience init(username: String, browniePoints: Int) {
		self.init()
		self.username = username
		self.browniePoints = browniePoints
//		self.id = UUID().description
	}

	override static func primaryKey() -> String? {
		return "username"
	}

}
