//
//  DownloadableImageView.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/12/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

class DownloadableImageView: UIImageView {
    var lastUsedUrl: URL?
    let imageHelper = ImageHelper(session: URLSession.shared)

    func getImage(from urlString: String?) {
        self.image = nil

        if let urlString = urlString, let url = URL(string: urlString) {
            lastUsedUrl = url
            imageHelper.getImage(from: url) { imageResult in
                DispatchQueue.main.async {
                    if let imageResult = imageResult, imageResult.url == self.lastUsedUrl {
                        self.image = imageResult.image
                    } else {
                        self.image = nil
                    }
                }
            }
        }
    }
}
