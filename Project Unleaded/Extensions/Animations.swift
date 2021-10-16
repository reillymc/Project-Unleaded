//
//  Animations.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 10/10/21.
//

import SwiftUI

extension Animation {
    static var heroTransition: Animation { .interactiveSpring(response: 0.45, dampingFraction: 0.75, blendDuration: 0.4) }
    
    static var rotateTransition: Animation { .interactiveSpring(response: 0.7, dampingFraction: 0.4, blendDuration: 0.6) }
    
    static var contentTransition: Animation { .easeInOut(duration: 0.2) }
}
