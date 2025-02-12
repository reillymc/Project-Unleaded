//
//  PrimaryCard.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI
import Combine
import MapKit
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}

let minimumDistance: Double = 12000 //m

struct HeroCard: View {
    
    /// .cardTransitionPercent goes from 0 to 1 when flying in, and from 1 to 0 when flying out.
    @Environment(\.cardTransitionPercent) var pct: CGFloat
    @Environment(\.appConfig) var config: AppConfig
    
    @State private var offset = CGSize.zero
    @State private var willRefresh = false
    @State private var showMap = false
    
    @ObservedObject var mapViewModel: MapViewModel
    
    @StateObject private var locationManager = LocationManager()

    let price: Price
    let priceList: [simplePrice]
    var refresh: (() -> Void)? = nil
    
    init (price: Price, priceList: [simplePrice], mapViewModel: MapViewModel, refresh: (() -> Void)?) {
        self.price = price
        self.refresh = refresh
        self.priceList = priceList
        self.mapViewModel = mapViewModel
        self.mapViewModel.coordinateRegion.center = CLLocationCoordinate2D(latitude: price.lat, longitude: price.lng)
        self.mapViewModel.coordinateLocation  = CLLocationCoordinate2D(latitude: price.lat, longitude: price.lng)
    }
    
    init (price: Price, priceList: [simplePrice], mapViewModel: MapViewModel) {
        self.price = price
        self.priceList = priceList
        self.mapViewModel = mapViewModel
        self.mapViewModel.coordinateRegion.center = CLLocationCoordinate2D(latitude: price.lat, longitude: price.lng)
        self.mapViewModel.coordinateLocation  = CLLocationCoordinate2D(latitude: price.lat, longitude: price.lng)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            // Interpolate values from detail card to full hero card based on the transition percent, from detail (0) to hero (1)
            let baseWidth = min(geometry.size.width, geometry.size.height) * config.heroCardSize.width
            let baseHeight = min(geometry.size.width, geometry.size.height) * config.heroCardSize.height
            
            let width = config.detailCardSize.width + (baseWidth - config.detailCardSize.width) * pct
            let height = config.detailCardSize.height + (baseHeight - config.detailCardSize.height) * pct
            let radius = config.detailCardRadius + (config.heroCardRadius - config.detailCardRadius) * pct
            
            let distance = locationManager.lastLocation?.distance(from: CLLocation(latitude: price.lat, longitude: price.lng)) ?? minimumDistance
            
            Color.clear.overlay(
                ZStack {
                    VStack(spacing: max(pct, 0.5) * 5){
                        if (!showMap || pct != 1 || willRefresh){
                            Image(systemName: willRefresh ? "arrow.up.circle.fill" : "fuelpump.circle.fill")
                                .font(.system(size: 60))
                                .padding(.bottom, pct * 10)
                                .scaleEffect(max(CGFloat.ulpOfOne, pct), anchor: .center)
                                .frame(width: 60, height: 60 * pct, alignment: .center)
                            HStack{
                                if !willRefresh { Image(systemName: "drop.fill").font(.footnote) }
                                Text(willRefresh ? "" : "\(price.type)").fontWeight(pct > 0.5 ? .bold : .regular)
                            }
                            Text(willRefresh ? "Refresh" : "\(price.price, specifier: "%.1f¢ ")")
                                .font(.system(size: 60)).fontWeight(.bold).scaleEffect(max(pct, 0.5), anchor: .center)
                                .frame(width: width, height: 60 * max(pct, 0.5), alignment: .center)
                            if !willRefresh {
                                HStack(spacing: 5){
                                    Image(systemName: "location.fill").font(.footnote)
                                    Text("\(price.suburb),")
                                        .fontWeight(pct > 0.5 ? .bold : .regular)
                                        .padding(0)
                                    if (pct > 0.5) {
                                        Text(price.state)
                                            .fontWeight(pct > 0.5 ? .bold : .regular)
                                            .scaleEffect(max(CGFloat.ulpOfOne, pct), anchor: .center)
                                            .padding(0)
                                    }
                                    Text(price.postcode)
                                        .fontWeight(pct > 0.5 ? .bold : .regular)
                                        .padding(0)
                                }
                                
                            }
                        }
                    }
                    if (pct == 1){
                        Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: price.lat, longitude: price.lng), span: MKCoordinateSpan(latitudeDelta: 0.22, longitudeDelta: 0.22)))) {
                            Annotation("", coordinate: CLLocationCoordinate2D(latitude: price.lat, longitude: price.lng), anchor: .center) {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.red.opacity(0.5))
                                        .frame(width: 40, height: 40)
                             
                                    Image(systemName: distance > minimumDistance ? "car.front.waves.up" : "checkmark")
                                        .symbolEffect(.variableColor)
                                        .padding(8)
                                        .foregroundStyle(.white)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                            }
                            UserAnnotation()
                        }
                            .hidden(!showMap || willRefresh)
                            .onAppear {
                                locationManager.locationManager.requestWhenInUseAuthorization()
                            }
                            .mapControlVisibility(.hidden)                            
                    }
                }
                    .id(self.willRefresh.hashValue)
                    .foregroundColor(.white)
                    .frame(width: width, height: height, alignment: .center)
                    .background(LinearGradient(gradient: Gradient(colors: willRefresh ? [Color(UIColor(named: "Secondary")!), Color(UIColor(named: "Primary")!)] : [Color(UIColor(named: "Primary")!), Color(UIColor(named: "Secondary")!)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                    .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: radius))
                    .contextMenu {
                        FuelPriceList.init(prices: priceList)
                    }
            )
                .shadow(radius: 8 * pct)
                .offset(x: offset.width / 3, y: (offset.height / 2) - (geometry.size.height * 0.12 * pct))
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
                .onTapGesture {
                    withAnimation(.rotateTransition){
                        showMap.toggle()
                    }
                }
                
        }
        
    }
}

struct HeroCard_Previews: PreviewProvider {
    
    static var previews: some View {
        HeroCard(price: Price(type: "U91", price: 133.3, name: "Waga-Waga", state: "QLD", postcode: "4282", suburb: "Oxenford", lat: -153.232, lng: 37.1923), priceList: [], mapViewModel: MapViewModel())
    }
}

class MapViewModel: ObservableObject {
    @Published var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.2744, longitude: 133.7751), span: MKCoordinateSpan(latitudeDelta: 2.9, longitudeDelta: 2.9))
    @Published var coordinateLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 25.2744, longitude: 133.7751)
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
