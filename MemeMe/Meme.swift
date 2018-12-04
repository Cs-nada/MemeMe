//
//  File.swift
//  MemeMe
//
//  Created by Ndoo H on 03/12/2018.
//  Copyright © 2018 Ndoo H. All rights reserved.
//

import Foundation
import UIKit

struct  Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
    
    // Constructor
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
