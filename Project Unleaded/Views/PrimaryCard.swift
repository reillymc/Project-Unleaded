//
//  HeaderDetailCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct PrimaryCard: View {
    let price: Price?
    
    var body: some View {
        if price != nil {
            VStack(spacing: 5){
                Image(systemName: "fuelpump.circle.fill").font(.system(size: 60)).padding(.bottom, 10)
                HStack{
                    Image(systemName: "drop.fill").font(.footnote)
                    Text("\(price!.type)").fontWeight(.bold)
                }
                Text("\(price!.price, specifier: "%.1f¢")").font(.system(size: 60)).fontWeight(.bold)
                HStack{
                    Image(systemName: "location.fill").font(.footnote)
                    Text("\(price!.suburb), \(price!.postcode)").fontWeight(.bold)
                    
                }
            }
            .foregroundColor(.white)
            
            .padding(.all, 10)
            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(named: "Primary")!), Color(UIColor(named: "Secondary")!)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(150)
            .shadow(radius: 5)
        } else {
            VStack{
                Text("Loading...")
            }
        }
        
    }
}

struct PrimaryCard_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryCard(price: Price(type: "U91", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923))
    }
}
