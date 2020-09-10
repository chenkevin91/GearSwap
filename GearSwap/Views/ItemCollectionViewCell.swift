//
//  ItemCollectionViewCell.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/10/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private (set) var imageView: UIImageView!
    @IBOutlet private (set) var priceLabel: UILabel!
    @IBOutlet private (set) var nameLabel: UILabel!
    @IBOutlet private (set) var sellerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.systemGray5.cgColor
        } else {
            layer.borderColor = UIColor.lightGray.cgColor
        }
        layer.borderWidth = 1
        layer.cornerRadius = 4
    }

}
