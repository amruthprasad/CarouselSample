//
//  CarBrandsModel.swift
//  CarouselSample
//
//  Created by AMRUTHAPRASAD KK on 05/05/21.
//  Copyright © 2021 MB. All rights reserved.
//

import Foundation

struct CarBrands: Codable {
    let data: [Brand]
}

struct Brand: Codable {
    let brand: String
    let url: String
    let models: [String]
}
