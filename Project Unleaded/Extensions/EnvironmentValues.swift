//
//  EnvironmentValues.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 10/10/21.
//

import SwiftUI

extension EnvironmentValues {
    var appPrefs: AppPrefs {
        get { return self[AppPrefsKey.self] }
        set { self[AppPrefsKey.self] = newValue }
    }
    
    var appConfig: AppConfig {
        get { return self[AppConfigKey.self] }
        set { self[AppConfigKey.self] = newValue }
    }
    
    var cardTransitionPercent: CGFloat {
        get { return self[ModalTransitionKey.self] }
        set { self[ModalTransitionKey.self] = newValue }
    }
}

public struct AppPrefsKey: EnvironmentKey {
    public static let defaultValue: AppPrefs = .general
}

public struct AppConfigKey: EnvironmentKey {
    public static let defaultValue: AppConfig = .portrait
}

public struct ModalTransitionKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0
}
