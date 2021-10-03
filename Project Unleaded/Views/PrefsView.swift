//
//  SwiftUIView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct PrefsView: View {
    @Environment(\.presentationMode) var presentationMode
        
    @AppStorage("U91") var FuelU91 = false
    @AppStorage("U98") var FuelU98 = false
    @AppStorage("E10") var FuelE10 = false
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Watchlist"), footer: Text("Selected fuels will be visible in the list at the bottom of the screen.")) {
                    Toggle("Unleaded 91", isOn: $FuelU91)
                    Toggle("Unleaded 98", isOn: $FuelU98)
                    Toggle("E10", isOn: $FuelE10)
                    Toggle("LPG", isOn: $FuelLPG)
                    Toggle("Diesel", isOn: $FuelDiesel)
                }
            }
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
}


struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
    }
}
