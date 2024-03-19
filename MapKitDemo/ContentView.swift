//
//  ContentView.swift
//  MapKitDemo
//
//  Created by ksd on 12/03/2024.
//

import SwiftUI
import MapKit

enum MapOptions: String, Identifiable, CaseIterable {
    case hybrid
    case imagery
    case standard
    var id: String {
        self.rawValue
    }
}

struct ContentView: View {
    @State private var cameraPosition = MapCameraPosition.automatic
    @State private var mapStyle: MapStyle = .standard
    @State private var mapStyleSelection: MapOptions = .standard
    @State private var showDetails = false
    @State private var route: MKRoute?
    @State private var markerSelection: Int?
    
    private func fetchRouteFrom(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        Task {
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: .Eaaa))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: .Tivoli))
            request.transportType = .automobile
            
            Task { @MainActor in
                let result = try? await MKDirections(request: request).calculate()
                self.route = result?.routes.first
            }
        }
    }
    
    
    var body: some View {
            Map(position: $cameraPosition, selection: $markerSelection) {
                Marker("Christiansborg", coordinate: .DanishParliament).tag(1)
                Marker("ChristianVII", coordinate: .ChristianVII).tag(2)
                Marker("Opera", coordinate: .Opera).tag(3)
                Marker("Tivoli", coordinate: .Tivoli).tag(4)
                Marker("Zoo", coordinate: .Zoo).tag(5)
                Marker("Eaaa", coordinate: .Eaaa).tag(6)
                if let route {
                    MapPolyline(route.polyline).stroke(.blue, lineWidth: 4)
                }
            }
            .onChange(of: markerSelection) {oldValue, newValue in
                //showDetails = true
                fetchRouteFrom(.Eaaa, to: .Zoo)
            }
            .ignoresSafeArea()
            .overlay(alignment: .topTrailing) {
                Picker("MapStyles", selection: $mapStyleSelection) {
                    ForEach(MapOptions.allCases) { mapOption in
                        Text(mapOption.rawValue.capitalized).tag(mapOption)
                    }
                }
                .pickerStyle(.segmented)
            }
            .onChange(of: mapStyleSelection){ oldValue, newValue in
                switch newValue {
                case .hybrid:
                    mapStyle = .hybrid
                case .imagery:
                    mapStyle = .imagery(elevation: .realistic)
                case .standard:
                    mapStyle = .standard
                }
            }
            .mapStyle(mapStyle)
            .onAppear {
                let copenhagenSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
                let copenhagenRegion = MKCoordinateRegion(center: CLLocationCoordinate2D.Copenhagen, span: copenhagenSpan)
                cameraPosition = .region(copenhagenRegion)
            }
            .sheet(isPresented: $showDetails) {
                Text("Hejsa")
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(250)))
                //.presentationCornerRadius(25)
                //.interactiveDismissDisabled(true)
            }
    }
}

#Preview {
    ContentView()
}
