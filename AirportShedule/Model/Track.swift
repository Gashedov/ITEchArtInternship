//
//  Track.swift
//  AirportShedule
//
//  Created by student on 5/14/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct Track: Codable {
    let startTime: Int
    let endTime: Int
    let path: [Waypoint]
}

extension Track {
    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
        case path
    }
}

struct Waypoint: Codable {
    let time: Int?
    let latitude: Float?
    let longitude: Float?
    let baro: Float?
    let trueTrack: Float?
    let onGround: Bool?

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.time = try container.decode(Int.self)
        self.latitude = try container.decode(Float.self)
        self.longitude = try container.decode(Float.self)
        self.baro = try container.decode(Float.self)
        self.trueTrack = try container.decode(Float.self)
        self.onGround = try container.decode(Bool.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(time)
        try container.encode(latitude)
        try container.encode(longitude)
        try container.encode(baro)
        try container.encode(trueTrack)
        try container.encode(onGround)
    }
}
