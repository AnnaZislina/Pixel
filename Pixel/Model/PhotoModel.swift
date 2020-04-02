//
//  PhotoModel.swift
//  Pixel
//
//  Created by Anna Zislina on 18/03/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation

class Photo: Codable {
    let height: Int
    let width: Int
    let photographer: String
    let url: String
    let src: Src
}
