//
//  GetCheapestFuelHandler.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 23/10/21.
//

import Foundation
import Intents

class CheapestFuelHandler: NSObject, CheapestFuelIntentHandling {
    func handle(intent: CheapestFuelIntent, completion: @escaping (CheapestFuelIntentResponse) -> Void) {
        completion(CheapestFuelIntentResponse.success(result: "The cheapest fuel price is 152.9 cents"))
    }
    
//    func handle(intent: CheapestFuelIntent) async -> CheapestFuelIntentResponse {
//        <#code#>
//    }
    
    
}


