//
//  ChartComponent.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 1/10/2023.
//

import SwiftUI
import Charts
import Foundation

func getMinPrice(prices: [PriceEntry]) -> Double {
    let minimum = prices.min { $0.price < $1.price }
    
    if let unwrappedMin = minimum {
        return unwrappedMin.price - 12
    } else {
        return 0
    }
}

func getMaxPrice(prices: [PriceEntry]) -> Double {
    let maximum = prices.max { $0.price < $1.price }
    
    if let unwrappedMax = maximum {
        return unwrappedMax.price + 12
    } else {
        return 0
    }
}

func getMinMax(priceHistory: PriceHistory, fuelU91: Bool, fuelU95: Bool,fuelU98: Bool,fuelE10: Bool, fuelLPG: Bool, fuelDiesel: Bool) -> (Double, Double) {
    var allPrices: [PriceEntry] = []
    
    
    if (fuelE10) {
        allPrices.append(contentsOf: priceHistory.E10)
    }
    if (fuelU91) {
        allPrices.append(contentsOf: priceHistory.U91)
    }
    if (fuelU95) {
        allPrices.append(contentsOf: priceHistory.U95)
    }
    if (fuelU98) {
        allPrices.append(contentsOf: priceHistory.U98)
    }
    if (fuelLPG) {
        allPrices.append(contentsOf: priceHistory.LPG)
    }
    if (fuelDiesel) {
        allPrices.append(contentsOf: priceHistory.Diesel)
    }
    
    let min = getMinPrice(prices: allPrices)
    let max = getMaxPrice(prices: allPrices)
    
    return (min, max)
}

struct ChartComponent: View {
    let priceHistory: PriceHistory
    let dateRange: String
    let fuelU91: Bool
    let fuelU95: Bool
    let fuelU98: Bool
    let fuelE10: Bool
    let fuelLPG: Bool
    let fuelDiesel: Bool
    
    @State var hoveredDate: Date?
    @State private var isDragging = false
    
    var body: some View {
        let minMax = getMinMax(priceHistory: priceHistory, fuelU91: fuelU91, fuelU95: fuelU95,fuelU98: fuelU98,fuelE10: fuelE10, fuelLPG: fuelLPG, fuelDiesel: fuelDiesel)
        
        Chart {
            if (fuelE10) {
                ForEach(priceHistory.E10) { priceEntry in
                    if (dateRange == "1m") {
                        PointMark(
                            x: .value("Date", priceEntry.date),
                            y: .value("Price", priceEntry.price)
                        )
                        .foregroundStyle(.green)
                        .symbolSize(20)
                        .position(by: .value("Type", "E10"))
                    }
                    LineMark(
                        x: .value("Date", priceEntry.date),
                        y: .value("Price", priceEntry.price),
                        series: .value("Type","E10")
                    )
                    .foregroundStyle(.green)
                    .position(by: .value("Type", "E10"))
                    .interpolationMethod(.catmullRom)
                }
            }
            if (fuelU91) {
                ForEach(priceHistory.U91) { priceEntry in
                    if (dateRange == "1m") {
                        PointMark(
                            x: .value("Date", priceEntry.date),
                            y: .value("Price", priceEntry.price)
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(20)
                        .position(by: .value("Type", "U91"))
                    }
                    LineMark(
                        x: .value("Date", priceEntry.date),
                        y: .value("Price", priceEntry.price),
                        series: .value("Type","U91")
                    )
                    .foregroundStyle(.blue)
                    .position(by: .value("Type", "U91"))
                    .interpolationMethod(.catmullRom)
                }
            }
            if (fuelU95) {
                ForEach(priceHistory.U95) { priceEntry in
                    if (dateRange == "1m") {
                        PointMark(
                            x: .value("Date", priceEntry.date),
                            y: .value("Price", priceEntry.price)
                        )
                        .foregroundStyle(.cyan)
                        .symbolSize(20)
                        .position(by: .value("Type", "U95"))
                    }
                    LineMark(
                        x: .value("Date", priceEntry.date),
                        y: .value("Price", priceEntry.price),
                        series: .value("Type","U95")
                    )
                    .foregroundStyle(.cyan)
                    .position(by: .value("Type", "U95"))
                    .interpolationMethod(.catmullRom)
                }
            }
            if (fuelU98) {
                ForEach(priceHistory.U98) { priceEntry in
                    if (dateRange == "1m") {
                        PointMark(
                            x: .value("Date", priceEntry.date),
                            y: .value("Price", priceEntry.price)
                        )
                        .foregroundStyle(.red)
                        .symbolSize(20)
                        .position(by: .value("Type", "U98"))
                    }
                    LineMark(
                        x: .value("Date", priceEntry.date),
                        y: .value("Price", priceEntry.price),
                        series: .value("Type","U98")
                    )
                    .foregroundStyle(.red)
                    .position(by: .value("Type", "U98"))
                    .interpolationMethod(.catmullRom)
                }
            }
            if (fuelLPG) {
                ForEach(priceHistory.LPG) { priceEntry in
                    if (dateRange == "1m") {
                        PointMark(
                            x: .value("Date", priceEntry.date),
                            y: .value("Price", priceEntry.price)
                        )
                        .foregroundStyle(.yellow)
                        .symbolSize(20)
                        .position(by: .value("Type", "LPG"))
                    }
                    LineMark(
                        x: .value("Date", priceEntry.date),
                        y: .value("Price", priceEntry.price),
                        series: .value("Type","LPG")
                    )
                    .foregroundStyle(.yellow)
                    .position(by: .value("Type", "LPG"))
                    .interpolationMethod(.catmullRom)
                }
            }
            if (fuelDiesel) {
                ForEach(priceHistory.Diesel) { priceEntry in
                    if (dateRange == "1m") {
                        PointMark(
                            x: .value("Date", priceEntry.date),
                            y: .value("Price", priceEntry.price)
                        )
                        .foregroundStyle(Color(UIColor(named: "Text")!))
                        .symbolSize(20)
                        .position(by: .value("Type", "Diesel"))
                    }
                    LineMark(
                        x: .value("Date", priceEntry.date),
                        y: .value("Price", priceEntry.price),
                        series: .value("Type","Diesel")
                    )
                    .foregroundStyle(Color(UIColor(named: "Text")!))
                    .position(by: .value("Type", "Diesel"))
                    .interpolationMethod(.catmullRom)
                }
            }
            
            if let hoveredDate {
                let halfDate = priceHistory.E10[priceHistory.E10.count / 2].date
                RuleMark(x: .value("Date", hoveredDate))
                    .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    .foregroundStyle(.gray)
                    .annotation(position: hoveredDate > halfDate ? .leading : .trailing){
                        VStack(spacing: 6){
                            Text(hoveredDate, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: true	, vertical: false)
                            
                            if let E10 = priceHistory.E10.first(where: { item in
                                return Calendar.current.compare(item.date, to: hoveredDate, toGranularity: .day) == ComparisonResult.orderedSame
                                
                            }), fuelE10 == true {
                                Text(String(format: "E10: %.1f", E10.price)).font(.caption.bold())
                            }
                            if let U91 = priceHistory.U91.first(where: { item in
                                return Calendar.current.compare(item.date, to: hoveredDate, toGranularity: .day) == ComparisonResult.orderedSame
                                
                            }), fuelU91 == true {
                                Text(String(format: "U91: %.1f", U91.price)).font(.caption.bold())
                            }
                            if let U95 = priceHistory.U95.first(where: { item in
                                return Calendar.current.compare(item.date, to: hoveredDate, toGranularity: .day) == ComparisonResult.orderedSame
                                
                            }), fuelU95 == true {
                                Text(String(format: "U95: %.1f", U95.price)).font(.caption.bold())
                            }
                            if let U98 = priceHistory.U98.first(where: { item in
                                return Calendar.current.compare(item.date, to: hoveredDate, toGranularity: .day) == ComparisonResult.orderedSame
                                
                            }), fuelU98 == true {
                                Text(String(format: "U98: %.1f", U98.price)).font(.caption.bold())
                            }
                            if let LPG = priceHistory.LPG.first(where: { item in
                                return Calendar.current.compare(item.date, to: hoveredDate, toGranularity: .day) == ComparisonResult.orderedSame
                                
                            }), fuelLPG == true {
                                Text(String(format: "LPG: %.1f", LPG.price)).font(.caption.bold())
                            }
                            if let Diesel = priceHistory.Diesel.first(where: { item in
                                return Calendar.current.compare(item.date, to: hoveredDate, toGranularity: .day) == ComparisonResult.orderedSame
                                
                            }), fuelDiesel == true {
                                Text(String(format: "Diesel: %.1f", Diesel.price)).font(.caption.bold())
                            }
                        }
                        
                        .padding(8)
                        .background(in: RoundedRectangle(cornerRadius: 8))
                    }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .automatic, position: .leading)
        }
        .chartXAxis {
            AxisMarks(preset: .automatic, position: .bottom)
        }
        .chartForegroundStyleScale([
            "E10": Color.green,
            "U91": Color.blue,
            "U95": Color.cyan,
            "U98": Color.red,
            "LPG": Color.yellow,
            "Diesel": Color(UIColor(named: "Text")!),
        ])
        .chartLegend(position: .top)
        .chartYScale(domain: minMax.0...minMax.1)
        .chartOverlay(content: { proxy in
            GeometryReader{innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 25.0)
                            .onChanged{value in
                                let location = value.location
                                
                                if let date: Date = proxy.value(atX: location.x) {
                                    hoveredDate = date
                                }
                            }
                            .onEnded{ value in
                                hoveredDate = nil
                            })
            }
        })
    }
}
