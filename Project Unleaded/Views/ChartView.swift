//
//  ChartView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 7/5/2023.
//

import SwiftUI
import Charts
import Foundation

struct SinglePrice: Identifiable {
    let id = UUID()
    let date: Date
    let type: String
    let amount: Double
}

struct ChartView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentTab = "1m"
    
    @State var prices: PriceHistory = PriceHistory(E10: [], U91: [], U95: [], U98: [], LPG: [], Diesel: [])
    
    
    // TODO: move to AppPrefs
    @AppStorage("U91") var FuelU91 = true
    @AppStorage("U95") var FuelU95 = true
    @AppStorage("U98") var FuelU98 = true
    @AppStorage("E10") var FuelE10 = true
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false
    
    
    func reload() async {
        API().getHistory(timeRange: currentTab) { (history) in
            self.prices = history
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ChartComponent(priceHistory: prices, dateRange: currentTab, fuelU91: FuelU91, fuelU95: FuelU95,fuelU98: FuelU98,fuelE10: FuelE10, fuelLPG: FuelLPG, fuelDiesel: FuelDiesel)
                    .padding()
                Picker("", selection: $currentTab) {
                    Text("1 Month").tag("1m")
                    Text("3 Months").tag("3m")
                    Text("6 Months").tag("6m")
                    Text("All Time").tag("All")
                    
                }.onChange(of: currentTab, initial: true) {
                    Task {
                        await reload()
                    }
                }
                .pickerStyle(.segmented).padding([.leading, .bottom, .trailing]).padding(.bottom, 20)
            }
            .padding(.top, 30)
            .navigationBarTitle(Text("Price History"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .accentColor(Color(UIColor(named: "Primary")!))
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
