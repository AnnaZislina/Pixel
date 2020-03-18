//
//  PexelsResponse.swift
//  Pixel
//
//  Created by Anna Zislina on 05/01/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation

struct PexelsResponse: Codable {
    let page: Int
    let per_page: Int
    let total_results: Int
   // let photos: [Photo]
    let photos: [PhotoModel]
}
