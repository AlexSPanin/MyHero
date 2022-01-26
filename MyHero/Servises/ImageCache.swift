//
//  ImageCache.swift
//  MyHero
//
//  Created by Александр Панин on 26.01.2022.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
