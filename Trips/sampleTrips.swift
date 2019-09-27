//
//  exampleTrips.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-09-18.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import Foundation
import SwiftUI

let packs = [Pack(name: "Tech", items: [Item(name: "Laptop")])]

let exampleTrips = [
    Trip(name: "Trip to Georgia", startDate: Date(timeIntervalSinceReferenceDate: 588200000), endDate: Date(timeIntervalSinceReferenceDate: 588804800), color: Color.red, icon: "house.fill", packs: packs),
    Trip(name: "Trip to Oregon", startDate: Date(timeIntervalSinceReferenceDate: 590515986), endDate: Date(timeIntervalSinceReferenceDate: 590516014), color: Color.blue, icon: "sunrise", packs: packs)
]
