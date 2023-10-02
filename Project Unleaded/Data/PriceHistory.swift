//
//  PriceHistory.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 7/5/2023.
//

import Foundation

struct PriceHistory: Codable {
    let E10: [PriceEntry]
    let U91: [PriceEntry]
    let U95: [PriceEntry]
    let U98: [PriceEntry]
    let LPG: [PriceEntry]
    let Diesel: [PriceEntry]
}


let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
}()


struct PriceEntry: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
    
    init(date: Date, price: Double = 0) {
        self.date = date
        self.price = price
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = dateFormatter.date(from: try values.decodeIfPresent(String.self, forKey: .date) ?? "") ?? Date()
        price = try values.decodeIfPresent(Double.self, forKey: .price) ?? 0
    }
}
