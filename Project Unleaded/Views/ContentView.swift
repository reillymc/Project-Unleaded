//
//  ContentView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 18/10/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Namespace var nspace
    
    @State private var prefs: AppPrefs
    @State private var config: AppConfig
    @State private var portraitConfig: AppConfig
    @State private var landscapeConfig: AppConfig
    
    @State private var showPrefsSheet: Bool = false
    @State private var isPortrait: Bool?
    
    @State private var priceList: [Price] = []
    @State private var selectedPrice: Price? = nil
    @State private var lastUpdated: String = "loading..."
    
    // TODO: move to AppPrefs
    @AppStorage("U91") var FuelU91 = true
    @AppStorage("U98") var FuelU98 = true
    @AppStorage("E10") var FuelE10 = true
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false
    
    init(prefs: AppPrefs = .general, portraitConfig: AppConfig = .portrait, landscapeConfig: AppConfig = .landscape) {
        self._prefs = State(initialValue: .general)
        self._config = State(initialValue: .portrait)
        self._landscapeConfig = State(initialValue: landscapeConfig)
        self._portraitConfig = State(initialValue: portraitConfig)
    }
    
    var body: some View {
        return ZStack {
            NavigationView {
                VStack{
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: self.config.listSpacing) {
                            ForEach(filterPrices(prices: priceList)) { item in
                                if item.id != self.selectedPrice?.id {
                                    DetailCard(price: item, hidden: false)
                                        .onTapGesture { tapDetailCard(item) }
                                        .matchedGeometryEffect(id: item.id, in: nspace, properties: .frame)
                                        .transition(.invisible)
                                } else {
                                    Color.clear.frame(width: 20, height: 5)
                                }
                            }
                        }.padding(config.listPadding)
                    }
                    Text(lastUpdated).foregroundColor(Color(UIColor(named: "Information")!))
                }
                .navigationTitle(Text("Your best price is..."))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.showPrefsSheet = true
                        }, label: {
                            Image(systemName: "gear").imageScale(.large).foregroundColor(Color(UIColor(named: "Primary")!))
                        })
                            .sheet(isPresented: self.$showPrefsSheet, content: PrefsView.init)
                    }
                    
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .zIndex(1)
            
            if self.selectedPrice != nil {
                Color.clear.overlay(
                    HeroCard(price: self.selectedPrice!, refresh: heroCardDrag)
                        .matchedGeometryEffect(id: self.selectedPrice!.id, in: nspace, properties: .position)
                )
                    .zIndex(3)
                    .transition(.modal)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.appConfig, config)
        .background(handleOrientationChange())
        .onAppear {
            Task {
                await reload()
            }
        }
        
    }
    
    func tapDetailCard(_ price: Price) {
        withAnimation(.heroTransition) {
            self.selectedPrice = nil
        }
        prefs.primaryFuel = price.id;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation(.heroTransition) {
                self.selectedPrice = price
            }
        }
    }
    
    func heroCardDrag() {
        self.lastUpdated = "Refreshing..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            Task {
                await reload()
            }
        }
    }
    
    func handleOrientationChange() -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                withAnimation(.rotateTransition) {
                    if geometry.size.height > geometry.size.width {
                        if !(self.isPortrait ?? false) {
                            if self.isPortrait != nil { self.landscapeConfig = self.config }
                            self.config = portraitConfig
                            self.isPortrait = true
                        }
                    } else {
                        if (self.isPortrait ?? true) {
                            if self.isPortrait != nil { self.portraitConfig = self.config }
                            self.config = landscapeConfig
                            self.isPortrait = false
                        }
                    }
                }
            }
            return .clear
        }
    }
    
    func reload() async {
        API().getData(dummy: true) { (priceList) in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            self.lastUpdated = "Last updated at \(formatter.string(from: Date(timeIntervalSince1970: Double(priceList.updated))))"
            self.priceList = priceList.regions.first(where: {$0.id == "Australia"})?.prices ?? []
            self.selectedPrice = self.priceList.first(where: {$0.id == prefs.primaryFuel})
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
        
        return prices.filter{enabledFuels.contains($0.id)}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
