//
//  FuelData.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 18/10/20.
//

import SwiftUI
import Combine

struct FuelData: Codable {
    var updated: Int
    var regions: [Region]
}

struct Region: Codable {
    var region: String
    var prices: [Price]
}

extension Region: Identifiable {
    var id: String { return region }
}

struct Price: Codable, Hashable {
    var type: String
    var price: Double
    var name: String
    var state: String
    var postcode: String
    var suburb: String
    var lat: Double
    var lng: Double
}

extension Price: Identifiable {
    var id: String { return type }
}

struct simplePrice: Identifiable {
    var id: String;
    var price: Double;
    var state: String;
    var postcode: String
    var suburb: String
}

enum RegionNames: CaseIterable, Hashable, Identifiable {
    case QLD
    case NSW
    case VIC
    case WA
    
    var name: String {
        return "\(self)".map {
            $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
    }
    var id: RegionNames {self}
}

enum FuelNames: CaseIterable, Hashable, Identifiable {
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
    var id: FuelNames {self}
}

final class UserData: ObservableObject  {
    @Published var showFavoritesOnly = false
    @Published var Fuels = ["U91", "U95", "U98", "E10", "Diesel", "LPG"]
    @Published var Regions = ["QLD", "NSW", "VIC", "WA"]
}


class API {
    func getData(dummy: Bool, completion: @escaping (FuelData) -> ()) {
        if (!dummy){
            
            guard let url = URL(string: "https://projectzerothree.info/api.php?format=json") else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                var priceList = try! JSONDecoder().decode(FuelData.self, from: data!)
                let formattedList = self.formatPriceList(priceList: &priceList)
                DispatchQueue.main.async {
                    completion(formattedList)
                }
            }
            .resume()
            
        } else {
            
            let path = Bundle.main.path(forResource: "dummyapi.json", ofType: nil)
            let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!))
            var priceList = try! JSONDecoder().decode(FuelData.self, from: jsonData)
            let formattedList = self.formatPriceList(priceList: &priceList)
            DispatchQueue.main.async {
                completion(formattedList)
            }
            
        }
        
    }
    
    func formatPriceList(priceList: inout FuelData) -> FuelData {
        priceList.regions[0].region = "Australia"
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
    
    func getHistory(completion: @escaping (PriceHistory) -> ()) {
        guard let url = URL(string: "https://d2aoe31r2phkds.cloudfront.net/history.json") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            var priceList = try! JSONDecoder().decode(PriceHistory.self, from: data!)
            DispatchQueue.main.async {
                completion(priceList)
            }
        }
        .resume()
    }
    
}
