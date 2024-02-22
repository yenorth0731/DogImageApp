//
//  type.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/19.
//

import Foundation


struct DogImage {
    var imageUrl: String
}

struct DogBreed {
    var name: String
    var images: [DogImage]
}
