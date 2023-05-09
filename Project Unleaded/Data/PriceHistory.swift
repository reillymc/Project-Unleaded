//
//  PriceHistory.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 7/5/2023.
//

import Foundation

struct PriceHistory: Codable {
    let history: [PriceEntry]
}


let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
}()


struct PriceEntry: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let E10: Double?
    let U91: Double?
    let U95: Double?
    let U98: Double?
    let LPG: Double?
    let Diesel: Double?
    
    
    init(date: Date, E10: Double? = nil, U91: Double? = nil, U95: Double? = nil, U98: Double? = nil, LPG: Double? = nil, Diesel: Double? = nil) {
        self.date = date
        self.E10 = E10
        self.U91 = U91
        self.U95 = U95
        self.U98 = U98
        self.LPG = LPG
        self.Diesel = Diesel
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = dateFormatter.date(from: try values.decodeIfPresent(String.self, forKey: .date) ?? "") ?? Date()
        E10 = try values.decodeIfPresent(Double.self, forKey: .E10)
        U91 = try values.decodeIfPresent(Double.self, forKey: .U91)
        U95 = try values.decodeIfPresent(Double.self, forKey: .U95)
        U98 = try values.decodeIfPresent(Double.self, forKey: .U98)
        LPG = try values.decodeIfPresent(Double.self, forKey: .LPG)
        Diesel = try values.decodeIfPresent(Double.self, forKey: .Diesel)
    }
}
