//
//  FriendCollectionViewCell.swift
//  BrowniePoints
//
//  Created by Peter Kos on 6/11/19.
//  Copyright © 2019 UW. All rights reserved.
//

import UIKit


class FriendCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var label: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

		label.textColor = .white
		contentView.backgroundColor = .brown
		contentView.layer.cornerRadius = 5.0

	}

}
