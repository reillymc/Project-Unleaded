//
//  ContentView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 18/10/20.
//

import SwiftUI

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct ContentView: View {
    @State var updated: String = ""
    @State var prices: [Price] = []
    @State var otherFuels: [Price] = []
    @State var primaryPrice: Price?
    @State var selectedFuel: String = UserDefaults.standard.string(forKey: "PrimaryFuel") ?? "U91"
    
    
    @State private var showModal = false
    
    @AppStorage("U91") var FuelU91 = false
    @AppStorage("U98") var FuelU98 = false
    @AppStorage("E10") var FuelE10 = false
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                PrimaryCard(price: prices.first(where: {$0.id == selectedFuel})).transition(.scale)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filterPrices(prices: prices)) { price in
                            DetailCard(price: price, hidden: selectedFuel == price.id)
                                .onTapGesture{
                                    withAnimation(.spring()) {
                                        self.selectedFuel = price.id
                                        UserDefaults.standard.set(price.id, forKey: "PrimaryFuel")
                                    }
                                }
                                .offset(x: 0, y: selectedFuel == price.id ? -1000 : 0)
                        }
                    }.padding(20)
                }
                Text("Last updated at \(updated)").foregroundColor(Color(UIColor(named: "Information")!))
            }
            
            .navigationBarTitle(Text("Your best price is..."))
            .navigationBarItems(trailing: Button(action: { self.showModal = true }) {
                Image(systemName: "gear").imageScale(.large).foregroundColor(Color(UIColor(named: "Primary")!))
            }
            )
            .refreshable {
                await reload()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(.background)
        
        .onAppear {
            async {
                await reload()
            }
        }
        .sheet(isPresented: $showModal, content: PrefsView.init)
        
    }
    
    func reload() async {
        API().getData(dummy: true) { (priceList) in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            self.updated = formatter.string(from: Date(timeIntervalSince1970: Double(priceList.updated))
            )
            self.prices = priceList.regions.first(where: {$0.id == "Australia"})?.prices ?? []
        }
    }
    
    func filterPrices(prices: [Price]) -> [Price] {
        
        var enabledFuels: [String] = []
        if (FuelU91 == true) {
            enabledFuels.append("U91")
        }
        if (FuelU98 == true) {
            enabledFuels.append("U98")
        }
        if (FuelE10 == true) {
            enabledFuels.append("E10")
        }
        if (FuelLPG == true) {
            enabledFuels.append("LPG")
        }
        if (FuelDiesel == true) {
            enabledFuels.append("Diesel")
        }
        
        //        return prices.filter{ $0.id.range(of: selectedFuel, options: .caseInsensitive) == nil }.filter{enabledFuels.contains($0.id)}
        return prices.filter{enabledFuels.contains($0.id)}
    }
    //    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
