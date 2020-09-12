//
//  ItemCollectionViewCell.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/10/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private (set) var imageView: DownloadableImageView!
    @IBOutlet private (set) var priceLabel: UILabel!
    @IBOutlet private (set) var nameLabel: UILabel!
    @IBOutlet private (set) var sellerLabel: UILabel!
    @IBOutlet private (set) var gradientView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientView.layer.addSublayer(gradientLayer)

        layer.borderColor = UIColor.grayBorder.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4

        priceLabel.font = .largeBoldFont
        priceLabel.textColor = .white

        nameLabel.font = .largeBoldFont

        sellerLabel.font = .smallFont
        sellerLabel.textColor = .darkGray
    }

    func configure(title: String, price: String, seller: String, imageURL: String) {
        nameLabel.text = title
        priceLabel.text = price
        sellerLabel.text = seller
        imageView.getImage(from: imageURL)
    }
}
