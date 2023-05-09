//
//  PrefsView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct PrefsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var prefs: AppPrefs
    
    init() {
        self._prefs = State(initialValue: .general)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Watchlist"), footer: Text("Selected fuels will be visible in the list at the bottom of the screen.")) {
                    Toggle("Unleaded 91", isOn: prefs.$FuelU91)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(named: "Primary")!)))
                    Toggle("Unleaded 95", isOn: prefs.$FuelU95)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(named: "Primary")!)))
                    Toggle("Unleaded 98", isOn: prefs.$FuelU98)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(named: "Primary")!)))
                    Toggle("E10", isOn: prefs.$FuelE10)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(named: "Primary")!)))
                    Toggle("LPG", isOn: prefs.$FuelLPG)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(named: "Primary")!)))
                    Toggle("Diesel", isOn: prefs.$FuelDiesel)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(named: "Primary")!)))
                }
                Section(header: Text("Guide"), footer: Text("Ensure each step is followed in order.")){
                    Text("1.  Ensure 7-Eleven app is closed")
                    Text("2.  Plug phone into computer")
                    Text("3.  Launch location faker")
                    Text("4.  Set location to cheapest fuel found")
                    Text("5.  Click start faking location")
                    Text("6.  Open 7-Eleven app and lock in price")
                    Text("7.  Quit 7-Eleven app")
                    Text("8.  Click stop faking location")
                    Text("9.  Unplug phone")
                }
            }
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
        }.accentColor(Color(UIColor(named: "Primary")!))
    }
    
}

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
    }
}
