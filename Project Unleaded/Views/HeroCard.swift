//
//  PrimaryCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI
import Combine

struct HeroCard: View {
    
    /// .cardTransitionPercent goes from 0 to 1 when flying in, and from 1 to 0 when flying out.
    @Environment(\.cardTransitionPercent) var pct: CGFloat
    @Environment(\.appConfig) var config: AppConfig
    
    @State private var offset = CGSize.zero
    @State private var willRefresh = false
    
    let price: Price
    var refresh: (() -> Void)? = nil
    
    init (price: Price, refresh: (() -> Void)?) {
        self.price = price
        self.refresh = refresh
    }
    
    init (price: Price) {
        self.price = price
    }
    
    var body: some View {
        
        // Interpolate values from detail card to full hero card based on the transition percent, from detail (0) to hero (1)
        let width = config.detailCardSize.width + (config.heroCardSize.width - config.detailCardSize.width) * pct
        let height = config.detailCardSize.height + (config.heroCardSize.height - config.detailCardSize.height) * pct
        let radius = config.detailCardRadius + (config.heroCardRadius - config.detailCardRadius) * pct
        
        return Color.clear.overlay(
            VStack(spacing: max(pct, 0.5) * 5){
                Image(systemName: willRefresh ? "arrow.up.circle.fill" : "fuelpump.circle.fill")
                    .font(.system(size: 60))
                    .padding(.bottom, pct * 10)
                    .scaleEffect(max(CGFloat.ulpOfOne, pct), anchor: .center)
                    .frame(width: 60, height: 60 * pct, alignment: .center)
                HStack{
                    Image(systemName: willRefresh ? "" : "drop.fill").font(.footnote)
                    Text(willRefresh ? "" : "\(price.type)").fontWeight(pct > 0.5 ? .bold : .regular)
                }
                Text(willRefresh ? "Refresh" : "\(price.price, specifier: "%.1f¢ ")")
                    .font(.system(size: 60)).fontWeight(.bold).scaleEffect(max(pct, 0.5), anchor: .center)
                    .frame(width: width, height: 60 * max(pct, 0.5), alignment: .center)
                HStack{
                    Image(systemName: willRefresh ? "" : "location.fill").font(.footnote)
                    Text(willRefresh ? "" : "\(price.suburb), \(price.postcode)").fontWeight(pct > 0.5 ? .bold : .regular)
                    
                }
            }
                .id(self.willRefresh.hashValue)
                .foregroundColor(.white)
                .frame(width: width, height: height, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: willRefresh ? [Color(UIColor(named: "Secondary")!), Color(UIColor(named: "Primary")!)] : [Color(UIColor(named: "Primary")!), Color(UIColor(named: "Secondary")!)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        )
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(radius: 8 * pct)
            .offset(x: offset.width / 3, y: (offset.height / 2) - (75 * pct)) //+ % of screen height
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                        if abs(self.offset.height) > 300 {
                            withAnimation(.contentTransition){
                                self.willRefresh = true
                            }
                        } else {
                            withAnimation(.contentTransition){
                                self.willRefresh = false
                            }
                        }
                    }
                
                    .onEnded { _ in
                        if abs(self.offset.height) > 300 {
                            refresh?()
                        }
                        self.willRefresh = false
                        withAnimation(.rotateTransition){
                            self.offset = .zero
                        }}
            )
            
            //.padding(.bottom, 175) //140ish on traceys phone
            

    }
}

struct HeroCard_Previews: PreviewProvider {
    
    static var previews: some View {
        HeroCard(price: Price(type: "U91", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923))
    }
}
