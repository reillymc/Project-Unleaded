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
    
    @State private var showModal = true
    
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
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showModal = true
                                    }) {
                                        Image(systemName: "gear").imageScale(.large).foregroundColor(Color( UIColor(red: 0.84, green: 0.15, blue: 0.24, alpha: 1.00)))
                                    }
            )
        }
        .onAppear {
            API().getData(dummy: true) { (priceList) in
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                self.updated = formatter.string(from: Date(timeIntervalSince1970: Double(priceList.updated))
                )
                self.regionList = priceList.regions
            }
        }.sheet(isPresented: $showModal, content: ModalView.init)
        
    }
    
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.editMode) var editMode
    
    @State var selectKeeperRegions:Set<String>  = UserDefaults.standard.mutableSetValue(forKey: "enabledRegions") as! Set<String>
    @State var selectKeeperFuels:Set<String>  = UserDefaults.standard.mutableSetValue(forKey: "enabledFuels") as! Set<String>
    
    
    @State var Regions = ["QLD", "NSW", "VIC", "WA"]
    @State var Fuels = ["U91", "U95", "U98", "E10", "Diesel", "LPG"]
    
    var body: some View {
        NavigationView {
            
            VStack {
                List(selection: $selectKeeperRegions) {
                    ForEach(Regions, id: \.self) { region in
                        Text(region).listRowBackground(Color.clear).onTapGesture {
                            UserDefaults.standard.set($selectKeeperRegions, forKey: "enabledRegions")
                        }
                    }
                    .onMove(perform: moveRegion)
                    
                }
                List(selection: $selectKeeperFuels) {
                    ForEach(Fuels, id: \.self) { fuel in
                        Text(fuel)
                    }
                    .onMove(perform: moveFuel)
                    .onTapGesture {
                        UserDefaults.standard.setValue($selectKeeperFuels, forKey: "enabledFuels")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
            .environment(\.editMode, .constant(.active))
        }
    }
    
    func moveRegion(from source: IndexSet, to destination: Int) {
        Regions.move(fromOffsets: source, toOffset: destination)
    }
    func moveFuel(from source: IndexSet, to destination: Int) {
        Fuels.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
