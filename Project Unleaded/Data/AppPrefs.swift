//
//  AppPrefs.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 10/10/21.
//

import SwiftUI

public struct AppPrefs {
    
    @AppStorage("U91") var FuelU91 = true
    @AppStorage("U95") var FuelU95 = true
    @AppStorage("U98") var FuelU98 = true
    @AppStorage("E10") var FuelE10 = true
    @AppStorage("LPG") var FuelLPG = false
    @AppStorage("DIESEL") var FuelDiesel = false
    
    let userDefaults = UserDefaults(suiteName: "group.reillymc.com.projectunleaded.getbestfuelprice")
    
    var primaryFuel: String {
        get { return userDefaults?.string(forKey: "PrimaryFuel") ?? "U91" }
        set { userDefaults?.set(newValue, forKey: "PrimaryFuel") }
    }
    
    /// The default configuration for app preferences
    public static let general = AppPrefs()
}
