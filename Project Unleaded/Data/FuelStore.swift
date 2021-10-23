//
//  FuelStore.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 19/10/21.
//

import Foundation
import SwiftUI

struct FuelStore {
    
    @AppStorage("fuelstore", store: UserDefaults(suiteName: "group.reillymc.com.projectunleaded.getbestfuelprice")) var store: Data = Data()
    
    var fuelPrices: [Price] = []
    
//    init() {
//        fuelPrices = getFuels()
//    }
    
//    func getFuels() -> [Price] {
//
//        var latest: [Price] = []
//        let decoder = JSONDecoder()
//
//        if let history = try? decoder.decode(FuelStore.self, from: store) {
//            latest = history.fuelPrices
//        }
//
//        return latest
//    }
//
//    func saveFuels(fuels: [Price]) -> Bool {
//        var result = true
//        let encoder = JSONEncoder()
//
//        if let data = try? encoder.encode(fuels) {
//            store = data
//        } else {
//            result = false;
//        }
//
//        return result
//    }
}
