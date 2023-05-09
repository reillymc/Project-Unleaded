//
//  ChartView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 7/5/2023.
//

import SwiftUI
import Charts
import Foundation


func getEarliestDate(currentTab: String) -> Date {
    var earliest = Date(timeIntervalSince1970: 0)
    
    
    if (currentTab == "1 Month") {
        earliest = Date(timeIntervalSinceNow: -2630000)
    }
    if (currentTab == "3 Months") {
        earliest = Date(timeIntervalSinceNow: -7890000)
    }
    if (currentTab == "6 Months") {
        earliest = Date(timeIntervalSinceNow: -15780000)
    }
    
    return earliest
}

func getMinPrice(prices: [SinglePrice]) -> Double {
    let minimum = prices.min { $0.amount < $1.amount }
    
    if let unwrappedMin = minimum {
        return unwrappedMin.amount - 15
    } else {
        return 0
    }
}

func getMaxPrice(prices: [SinglePrice]) -> Double {
    let maximum = prices.max { $0.amount < $1.amount }
    
    if let unwrappedMax = maximum {
        return unwrappedMax.amount + 15
    } else {
        return 0
    }
}

struct SinglePrice: Identifiable {
    let id = UUID()
    let date: Date
    let type: String
    let amount: Double
}

struct ChartView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentTab = "1 Month"
    
    @State var prices: [PriceEntry] = []
    
    
    // TODO: move to AppPrefs
    @AppStorage("U91") var FuelU91 = true
    @AppStorage("U95") var FuelU95 = true
    @AppStorage("U98") var FuelU98 = true
    @AppStorage("E10") var FuelE10 = true
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false
    
    
    func reload() async {
        API().getHistory() { (history) in
            self.prices = history.history
        }
    }
    
    var body: some View {
        let earliest = getEarliestDate(currentTab: currentTab)
        
        let filteredPrices = prices.filter { $0.date > earliest }
        
        let mappedPrices = filteredPrices.flatMap { price -> [SinglePrice] in
            var priceArray: [SinglePrice] = []
            if FuelE10 == true, let E10 = price.E10 {
                priceArray.append(SinglePrice(date: price.date, type: "E10", amount: E10))
            }
            if FuelU91 == true, let U91 = price.U91{
                priceArray.append(SinglePrice(date: price.date, type: "U91", amount: U91))
            }
            if FuelU95 == true, let U95 = price.U95{
                priceArray.append(SinglePrice(date: price.date, type: "U95", amount: U95))
            }
            if FuelU98 == true, let U98 = price.U98{
                priceArray.append(SinglePrice(date: price.date, type: "U98", amount: U98))
            }
            
            if FuelLPG == true, let LPG = price.LPG {
                priceArray.append(SinglePrice(date: price.date, type: "LPG", amount: LPG))
            }
            if FuelDiesel == true, let Diesel = price.Diesel {
                priceArray.append(SinglePrice(date: price.date, type: "Diesel", amount: Diesel))
            }
            
            return priceArray
        }
        
        NavigationView {
            VStack{
                ChartComponent(prices: mappedPrices, priceHistory: prices, currentTab: currentTab)
                    .padding()
                Picker("", selection: $currentTab) {
                    Text("1 Month").tag("1 Month")
                    Text("3 Months").tag("3 Months")
                    Text("6 Months").tag("6 Months")
                    Text("All Time").tag("All Time")
                    
                }.pickerStyle(.segmented).padding([.leading, .bottom, .trailing]).padding(.bottom, 20)
            }
            .padding(.top, 30)
            .navigationBarTitle(Text("Price History"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
            .accentColor(Color(UIColor(named: "Primary")!))
            .onAppear {
                Task {
                    await reload()
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(prices: [
            PriceEntry(date: dateFormatter.date(from: "2022-07-01") ?? Date(), E10: 110.0, U91: 125.0, U95: 139.4, U98: 136.9),
            PriceEntry(date: dateFormatter.date(from: "2022-12-08") ?? Date(), E10: 120.0, U91: 145.0, U95: 149.4, U98: 141.9),
            PriceEntry(date: dateFormatter.date(from: "2023-02-01") ?? Date(), E10: 140.0, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-02-04") ?? Date(), E10: 141.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-03-02") ?? Date(), E10: 132.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-06") ?? Date(), E10: 143.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-07") ?? Date(), E10: 144.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-08") ?? Date(), E10: 145.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-09") ?? Date(), E10: 146.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-10") ?? Date(), E10: 142.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-12") ?? Date(), E10: 143.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-16") ?? Date(), E10: 144.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-04-24") ?? Date(), E10: 143.7, U91: 165.0, U95: 159.4, U98: 181.9),
            PriceEntry(date: dateFormatter.date(from: "2023-05-01") ?? Date(), E10: 144.3, U91: 167.9, U95: 156.2, U98: 177.5),
            PriceEntry(date: dateFormatter.date(from: "2023-05-03") ?? Date(), E10: 145.8, U91: 162.4, U95: 154.5, U98: 171.7),
            PriceEntry(date: dateFormatter.date(from: "2023-05-05") ?? Date(), E10: 144.3, U91: 162.9, LPG: 84, Diesel: 99),
            PriceEntry(date: dateFormatter.date(from: "2023-05-06") ?? Date(), U91: 161.9, U95: 152.2, U98: 167.5, LPG: 85, Diesel: 98),
            PriceEntry(date: dateFormatter.date(from: "2023-05-07") ?? Date(), E10: 148.3, U91: 168.9, U95: 156.2, U98: 188.5)
        ])
    }
}

struct ChartComponent: View {
    let prices: [SinglePrice]
    let priceHistory: [PriceEntry]
    let currentTab: String
    
    @State var activeItem: PriceEntry?
    
    // TODO: move to AppPrefs
    @AppStorage("U91") var FuelU91 = true
    @AppStorage("U95") var FuelU95 = true
    @AppStorage("U98") var FuelU98 = true
    @AppStorage("E10") var FuelE10 = true
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false
    
    var body: some View {
        Chart(prices) { price in
            if (currentTab == "1 Month" || currentTab == "3 Months" ) {
                PointMark(
                    x: .value("Day", price.date),
                    y: .value("Price", price.amount)
                )
                .symbolSize(20)
                .foregroundStyle(by: .value("Type", price.type))
                .position(by: .value("Type", price.type))
            }
            
            LineMark(
                x: .value("Day", price.date),
                y: .value("Price", price.amount),
                series: .value("Type", price.type)
            )
            .foregroundStyle(by: .value("Type", price.type))
            .position(by: .value("Type", price.type))
            .interpolationMethod(.catmullRom)
            
            if let activeItem {
                let halfDate = prices[prices.count / 2].date
                RuleMark(x: .value("Day", activeItem.date))
                    .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    .foregroundStyle(.gray)
                    .annotation(position: activeItem.date > halfDate ? .leading : .trailing){
                        VStack(alignment: .leading, spacing: 6){
                            Text(activeItem.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                            if let E10 = activeItem.E10, FuelE10 == true {
                                Text(String(format: "E10: %.1f", E10))
                                    .font(.caption.bold())
                            }
                            if let U91 = activeItem.U91, FuelU91 == true {
                                Text(String(format: "U91: %.1f", U91))
                                    .font(.caption.bold())
                            }
                            if let U95 = activeItem.U95, FuelU95 == true {
                                Text(String(format: "U95: %.1f", U95))
                                    .font(.caption.bold())
                            }
                            if let U98 = activeItem.U98, FuelU98 == true {
                                Text(String(format: "U98: %.1f", U98))
                                    .font(.caption.bold())
                            }
                            if let LPG = activeItem.LPG, FuelLPG == true {
                                Text(String(format: "LPG: %.1f", LPG))
                                    .font(.caption.bold())
                            }
                            if let Diesel = activeItem.Diesel, FuelDiesel == true {
                                Text(String(format: "Diesel: %.1f", Diesel))
                                    .font(.caption.bold())
                            }
                        }
                        .padding(8)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                
            }
        }
        
        .chartYAxis {
            AxisMarks(preset: .automatic, position: .leading)
        }
        .chartXAxis {
            AxisMarks(preset: .automatic, position: .bottom)
        }
        .chartYScale(domain: getMinPrice(prices: prices)...getMaxPrice(prices: prices))
        .chartForegroundStyleScale([
            "E10": Color.green,
            "U91": Color.blue,
            "U95": Color.cyan,
            "U98": Color.red,
            "LPG": Color.yellow,
            "Diesel": Color(UIColor(named: "Text")!),
        ])
        .chartLegend(position: .top)
        .chartOverlay(content: { proxy in
            GeometryReader{innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                let location = value.location
                                
                                
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let ymd = calendar.dateComponents([.year, .month, .day], from: date)
                                    if let currentItem = priceHistory.first(where: { item in
                                        let itemDate = calendar.dateComponents([.year, .month, .day], from: item.date)
                                        
                                        return itemDate.year == ymd.year && itemDate.month == ymd.month && itemDate.day == ymd.day
                                    }) {
                                        activeItem = currentItem
                                    }
                                }
                            }.onEnded{ value in
                                activeItem = nil
                            })
            }
        })
    }
}
