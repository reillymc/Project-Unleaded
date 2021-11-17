//
//  FuelPriceList.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 17/11/21.
//

import SwiftUI

struct FuelPriceList: View {
    let prices: [simplePrice]
    
    var body: some View {
        Group {
            ForEach(prices) { item in
                Text("\(item.price, specifier: "%.1f¢ ") - \(item.suburb), \(item.state) \(item.postcode)")
            }
        }
    }
}

struct FuelPriceList_Previews: PreviewProvider {
    static var previews: some View {
        FuelPriceList(prices: [])
    }
}
