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
            }
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
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
