//
//  ContentView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 18/10/20.
//

import SwiftUI

struct ContentView: View {
    @State var updated: String = ""
    @State var region: Region?
    
    
    var body: some View {
        SummaryCard(pricelist: region?.prices)
            .onAppear {
                API().getData(dummy: false) { (priceList) in
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    self.updated = formatter.string(from: Date(timeIntervalSince1970: Double(priceList.updated))
                    )
                    self.region = priceList.regions.first(where: {$0.id == "Australia"})
                }
            }
        Text(updated)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
