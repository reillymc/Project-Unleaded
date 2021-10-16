//
//  AppConfig.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

public struct AppConfig {
    
    /// Card list spacing
    var listSpacing: CGFloat = 20
    
    /// Detail card
    var detailCardSize: CGSize = CGSize(width: 210, height: 150) //240ish on traceys phone
    var detailCardRadius: CGFloat = 20
    
    /// Hero card
    var heroCardSize: CGSize = CGSize(width: 350, height: 350) //300ish on tracey
    var heroCardRadius: CGFloat = 175

    
    /// The default configuration for portrait layouts using preset default values
    public static let portrait = AppConfig()
    
    /// The default configuration for landscape layouts
    public static let landscape = AppConfig(
        listSpacing: 30,
        detailCardSize: CGSize(width: 280, height: 100),
        detailCardRadius: 20,
        heroCardSize: CGSize(width: 400, height: 200),
        heroCardRadius: 200)
    

    init() {}
    
    init(listSpacing: CGFloat, detailCardSize: CGSize,  detailCardRadius: CGFloat, heroCardSize: CGSize, heroCardRadius: CGFloat) {
        self.listSpacing = listSpacing
        self.detailCardSize = detailCardSize
        self.detailCardRadius = detailCardRadius
        self.heroCardSize = heroCardSize
        self.heroCardRadius = heroCardRadius
    }
}

