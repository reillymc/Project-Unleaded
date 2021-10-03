//
//  HeaderDetailCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct SummaryCard: View {
    let pricelist: [Price]?
    
    var body: some View {
        
        //Favs
        ForEach(pricelist?.filter({$0.type == "U91"}) ?? []) { priceData in
            VStack{
                Image(systemName: "car.fill").font(.largeTitle).padding(5)
                Text("\(priceData.type)")
                Text("\(priceData.price, specifier: "%.1f¢")").font(.title)
                HStack{
                    Image(systemName: "location").font(.footnote)
                    Text("\(priceData.suburb), \(priceData.postcode)")
                    
                }
            }
            .frame(alignment: .center).padding()
        }
        GeometryReader() { proxy in
            if proxy.size.width < proxy.size.height {
                VStack{
                    //The Rest
                    ForEach(pricelist?.filter({$0.type != "Diesel" && $0.type != "LPG" && $0.type != "U91"}).sorted(by: { $0.type < $1.type }) ?? []) { priceData in
                        VStack{
                            Text("\(priceData.type)")
                            Text("$\(priceData.price, specifier: "%.1f¢")")
                            HStack{
                                Image(systemName: "location").font(.footnote)
                                Text("\(priceData.suburb), \(priceData.postcode)")
                                
                            }
                        }
                        
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color( UIColor(red: 0.84, green: 0.15, blue: 0.24, alpha: 1.00))
                    )
                    .cornerRadius(20).shadow(radius: 5 )
                    
                }
            } else {
                HStack{
                    //The Rest
                    ForEach(pricelist?.filter({$0.type != "Diesel" && $0.type != "LPG" && $0.type != "U91"}).sorted(by: { $0.type < $1.type }) ?? []) { priceData in
                        VStack{
                            Text("\(priceData.type)")
                            Text("\(priceData.price, specifier: "%.1f¢")")
                            HStack{
                                Image(systemName: "location").font(.footnote)
                                Text("\(priceData.suburb), \(priceData.postcode)")
                            }
                        }
                        
                    }
                    .frame(width: proxy.size.width / 3, height: proxy.size.height, alignment: .center)
                    .background(Color( UIColor(red: 0.84, green: 0.15, blue: 0.24, alpha: 1.00))
                    )
                    .cornerRadius(20).shadow(radius: 5 )
                }
               
            }
        }
        .frame(alignment: .center).padding()
    }
}

struct SummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        SummaryCard(pricelist: [Price(type: "U95", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923)])
    }
}
