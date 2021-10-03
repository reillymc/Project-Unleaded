//
//  DetailCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct DetailCard: View {
    let price: Price
    var hidden: Bool
    
    var body: some View {
        VStack(spacing: 10){
            //  Image(systemName: "car.fill").font(.largeTitle).padding(5)
            HStack{
                Image(systemName: "drop.fill").font(.footnote)
                Text("\(price.type)")
            }
            Text("\(price.price, specifier: "%.1f¢")").font(.title).fontWeight(.bold)
            HStack{
                Image(systemName: "location.fill").font(.footnote)
                Text("\(price.suburb), \(price.postcode)")
                
            }
        }
        .frame(width: hidden ? 0 : 240, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(named: "Primary")!), Color(UIColor(named: "Secondary")!)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .shadow(radius: 5 )
        .padding(.all, 10)
        .foregroundColor(.white)
    }
    
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(price: Price(type: "U91", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923), hidden: false)
    }
}
