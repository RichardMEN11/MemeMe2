//
//  Meme.swift
//  MemeMe2
//
//  Created by Richard Menning on 02.05.18.
//  Copyright © 2018 Richard Menning. All rights reserved.
//

import Foundation
import UIKit

struct Meme{
    var topText: String?
    var bottomText: String?
    var image: UIImage?
    var memedImage: UIImage?
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
