//
//  DetailCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct DetailCard: View {
    let pricelist: [Price]
    
    var body: some View {
        ForEach(pricelist) { priceData in
            VStack{
                Image(systemName: "car.fill").font(.largeTitle).padding(5)
                Text("\(priceData.type)")
                Text("$\(priceData.price, specifier: "%.1f¢")")
                HStack{
                    Image(systemName: "location").font(.footnote)
                    Text("\(priceData.suburb), \(priceData.postcode)")
                    
                }
            }
            
        }.frame(width: 240, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color( UIColor(red: 0.9, green: 0.4, blue: 0.24, alpha: 1.00))
        ).cornerRadius(20).shadow(radius: 5 ).padding(.all, 10)
    }
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(pricelist: [Price(type: "U91", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923)])
    }
}
