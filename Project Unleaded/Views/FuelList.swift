//
//  FuelList.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 7/5/21.
//

import SwiftUI

struct FuelList: View {
    @State private var showModal = false
    @State var updated: String = ""
    @State var regionList: [Region]
    
    var body: some View {
        ScrollView{
            LazyVStack() {
                ForEach(regionList) { region in
                    Section(header: Text(region.region).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().frame(alignment: .leading)
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                if (region.region == "Australia"){
                                    HeaderDetailCard(pricelist: region.prices)
                                } else {
                                   // DetailCard(pricelist: region.prices)
                                }
                            }.padding(.leading, 10)
                            
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Cheapest Fuel"))
        
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.showModal = true
                                }) {
                                    Image(systemName: "gear").imageScale(.large).foregroundColor(Color( UIColor(red: 0.84, green: 0.15, blue: 0.24, alpha: 1.00)))
                                }
        )
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            API().getData(dummy: true) { (priceList) in
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                self.updated = formatter.string(from: Date(timeIntervalSince1970: Double(priceList.updated))
                )
                self.regionList = priceList.regions
            }
        }.sheet(isPresented: $showModal, content: SettingsView.init)
    }
}

struct FuelList_Previews: PreviewProvider {
    static var previews: some View {
        FuelList(regionList:  [])
    }
}
