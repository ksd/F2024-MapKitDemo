//
//  MapClickView.swift
//  MapKitDemo
//
//  Created by ksd on 19/03/2024.
//

import SwiftUI
import MapKit

struct MapClickView: View {
    
    @EnvironmentObject var locationManager: LocationController
    
    var body: some View {
        MapReader { reader in
            Map(position: $locationManager.userCameraPosition)
                .onTapGesture(perform: { screenCoord in
                    let location = reader.convert(screenCoord, from: .local)
                })
        }
        .onAppear {
            locationManager.checkIflocationIsEnabled()
        }
    }
}

#Preview {
    MapClickView()
}
