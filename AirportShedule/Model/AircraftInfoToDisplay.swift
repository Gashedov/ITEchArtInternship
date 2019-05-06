//
//  Aircraft.swift
//  AirportShedule
//
//  Created by student on 5/6/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct Aircraft: Decodable {
    let productionLine: String?
    let planeModel: String?
    let modelCode : String?
    let registrationDate: String?
    let planeAge: String?
    let planeOwner: String?
}
