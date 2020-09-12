//
//  ImageCache.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/12/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation
import UIKit

struct ImageResult {
    let image: UIImage
    let url: URL
}

class ImageCache {
    private lazy var imageCache = NSCache<AnyObject, AnyObject>()
    private let lock = NSLock()

    func image(for key: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }

        return imageCache.object(forKey: key as AnyObject) as? UIImage
    }

    func insertImage(_ image: UIImage, for url: URL) {
        lock.lock(); defer { lock.unlock() }

        imageCache.setObject(image, forKey: url as AnyObject)
    }
}

struct ImageHelper {
    private let cache = ImageCache()

    func getImage(from url: URL, completion: @escaping (ImageResult?) ->()) {
        if let image = cache.image(for: url) {
            completion(ImageResult(image: image, url: url))
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Image Request Error: \(error?.localizedDescription ?? "missing error")")
                    return
                }

                if let image = UIImage(data: data) {
                    self.cache.insertImage(image, for: url)
                    completion(ImageResult(image: image, url: url))
                    return
                }
                completion(nil)
                return
            }.resume()
        }
    }
}
