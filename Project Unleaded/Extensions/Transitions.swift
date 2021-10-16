//
//  Transitions.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 10/10/21.
//  Adapted from: https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SwiftUI

extension AnyTransition {
    /// This transition will pass a value (0.0 - 1.0), indicating how much of the
    /// transition has passed. To communicate with the view, it will
    /// use the custom environment key .cardTransitionPercent
    /// it will also make sure the transitioning view is not faded in or out and it
    /// stays visible at all times.
    static var modal: AnyTransition {
        AnyTransition.modifier(
            active: CardExpansionModifier(pct: 0),
            identity: CardExpansionModifier(pct: 1)
        )
    }
    
    struct CardExpansionModifier: AnimatableModifier {
        var pct: CGFloat
        
        var animatableData: CGFloat {
            get { pct }
            set { pct = newValue }
        }
        
        func body(content: Content) -> some View {
            return content
                .environment(\.cardTransitionPercent, pct)
                .opacity(1.0)
        }
    }
    
    /// This transition will cause the view to disappear,
    /// until the last frame of the animation is reached
    static var invisible: AnyTransition {
        AnyTransition.modifier(
            active: InvisibleModifier(pct: 0),
            identity: InvisibleModifier(pct: 1)
        )
    }
    
    struct InvisibleModifier: AnimatableModifier {
        var pct: Double
        
        var animatableData: Double {
            get { pct }
            set { pct = newValue }
        }
        
        
        func body(content: Content) -> some View {
            content.opacity(pct == 1.0 ? 1 : 0)
        }
    }
}
