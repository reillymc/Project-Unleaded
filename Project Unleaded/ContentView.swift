//
//  ContentView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 18/10/20.
//

import SwiftUI

struct ContentView: View {
    @State var updated: String = ""
    @State var regionList: [Region] = []
    
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVStack() {
                    ForEach(regionList) { region in
                        Section(header: Text(region.region)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    if (region.region == "Australia"){
                                        ForEach(region.prices) { priceData in
                                            VStack{
                                                Image(systemName: "car.fill").font(.largeTitle).padding(5)
                                                Text("\(priceData.type)")
                                                Text("$\(priceData.price, specifier: "%.1f¢")")
                                                HStack{
                                                    Image(systemName: "location").font(.footnote)
                                                    Text("\(priceData.suburb), \(priceData.postcode)")
                                                    
                                                }
                                            }
                                            
                                        }.frame(width: 240, height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color( UIColor(red: 0.84, green: 0.15, blue: 0.24, alpha: 1.00))
                                        ).cornerRadius(20).shadow(radius: 5 ).padding(.all, 10)
                                    } else {
                                        ForEach(region.prices) { priceData in
                                            VStack{
                                                Image(systemName: "car.fill").font(.largeTitle).padding(5)
                                                Text("\(priceData.type)")
                                                Text("\(priceData.price, specifier: "%.1f")¢")
                                                HStack{
                                                    Image(systemName: "location").font(.footnote)
                                                    Text("\(priceData.suburb), \(priceData.postcode)")
                                                    
                                                }
                                            }
                                            
                                        }.frame(width: 240, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color( UIColor(red: 0.84, green: 0.15, blue: 0.24, alpha: 1.00))
                                        ).cornerRadius(20).shadow(radius: 5 ).padding(.all, 10)
                                        
                                    }
                                }.padding(.leading, 10)
                                
                            }
                        }
                    }
                }
                Text("Last Updated: \(updated)")
            }.navigationBarTitle(Text("Cheapest Fuel"))
        }
        .onAppear {
            API().getData(dummy: true) { (priceList) in
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                self.updated = formatter.string(from: Date(timeIntervalSince1970: Double(priceList.updated))
                )
                self.regionList = priceList.regions
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
