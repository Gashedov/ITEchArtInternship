//
//  DetailInfoImageAttriburs.swift
//  AirportShedule
//
//  Created by student on 5/6/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct Image: Decodable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let urls: ImageSize
}

struct ImageSize: Decodable {
    let full: String
    let regular: String
    let small: String
}

enum Orientation: String {
    case landscape
    case portrait
    case squarish
}
