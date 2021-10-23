//
//  GetCheapestFuelHandler.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 23/10/21.
//

import Foundation
import Intents

class CheapestFuelHandler: NSObject, CheapestFuelIntentHandling {
    func handle(intent: CheapestFuelIntent, completion: @escaping (CheapestFuelIntentResponse) -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.reillymc.com.projectunleaded.getbestfuelprice")

        let primaryFuel = userDefaults?.string(forKey: "PrimaryFuel") ?? "U91"
        getData() { (priceList) in
            let price = priceList.regions.first(where: {$0.region == "All"})?.prices.first(where: {$0.type == primaryFuel})
            let timeSinceUpdate = Int((Date().timeIntervalSince1970 - Double(priceList.updated)) / 60)
            if price != nil {
            
                completion(CheapestFuelIntentResponse.success(result: "The cheapest fuel price for \(primaryFuel) is \(price!.price) cents in \(price!.suburb) \(price!.state), last updated \(timeSinceUpdate) minutes ago."))
            }
        }
        
        
    }
}

func getData(completion: @escaping (FuelData2) -> ()) {
        guard let url = URL(string: "https://projectzerothree.info/api.php?format=json") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            var priceList = try! JSONDecoder().decode(FuelData2.self, from: data!)
            let formattedList = formatPriceList(priceList: &priceList)
            DispatchQueue.main.async {
                completion(formattedList)
            }
        }
        .resume()
}


func formatPriceList(priceList: inout FuelData2) -> FuelData2 {
   // priceList.regions[0].region = "Australia"
    priceList.regions.removeAll { (region) -> Bool in
        region.id.contains("-")
    }
    priceList.regions.sort { (a, b) -> Bool in
        let defaultOrder = ["QLD", "NSW", "VIC", "ACT", "WA", "SA"]
        if let first = defaultOrder.firstIndex(of: a.region), let second = defaultOrder.firstIndex(of: b.region) {
            return first < second
        }
        return false
    }
    for index in priceList.regions.indices {
        priceList.regions[index].prices.sort { (a, b) -> Bool in
            let defaultOrder = ["U91", "U98", "E10", "U95", "Diesel", "LPG"]
            if let first = defaultOrder.firstIndex(of: a.type), let second = defaultOrder.firstIndex(of: b.type) {
                return first < second
            }
            return false
        }
    }
    
    return priceList
}


struct FuelData2: Codable {
    var updated: Int
    var regions: [Region2]
}

struct Region2: Codable {
    var region: String
    var prices: [Price2]
}

extension Region2: Identifiable {
    var id: String { return region }
}

struct Price2: Codable, Hashable {
    var type: String
    var price: Double
    var name: String
    var state: String
    var postcode: String
    var suburb: String
    var lat: Double
    var lng: Double
}

extension Price2: Identifiable {
    var id: String { return type }
}

enum RegionNames2: CaseIterable, Hashable, Identifiable {
    case QLD
    case NSW
    case VIC
    case WA

    var name: String {
        return "\(self)".map {
            $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
    }
    var id: RegionNames2 {self}
}

enum FuelNames2: CaseIterable, Hashable, Identifiable {
    case U91
    case U95
    case U98
    case E10
    case Diesel
    case LPG

    var name: String {
        return "\(self)".map {
            $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
    }
    var id: FuelNames2 {self}
}

