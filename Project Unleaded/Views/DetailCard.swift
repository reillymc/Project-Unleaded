//
//  DetailCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

/// This view shows a picture, that may be zoomed and cropped (insetted)
struct DetailCard: View {
    @Environment(\.appConfig) var config: AppConfig
    
    let price: Price
    let priceList: [simplePrice]
    var hidden: Bool
    
    var body: some View {
        Color.clear.overlay(
            VStack {
                HStack{
                    Image(systemName: "drop.fill").font(.footnote)
                    Text("\(price.type)")
                }
                Text("\(price.price, specifier: "%.1f¢")").font(.system(size: 30)).fontWeight(.bold).frame(width: config.detailCardSize.width)
                HStack(spacing: 5){
                    Image(systemName: "location.fill").font(.footnote)
                    Text("\(price.suburb),")
                        .fontWeight(.regular)
                        .padding(0)
                    Text(price.postcode)
                        .fontWeight(.regular)
                        .padding(0)
                }
            }
        )
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(named: "Primary")!), Color(UIColor(named: "Secondary")!)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: config.detailCardRadius))
            .contentShape(RoundedRectangle(cornerRadius: config.detailCardRadius))
            .frame(width: config.detailCardSize.width, height: config.detailCardSize.height )
            .contextMenu {
                FuelPriceList.init(prices: priceList)
            }
    }
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(price: Price(type: "U91", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923), priceList: [], hidden: false)
    }
}
