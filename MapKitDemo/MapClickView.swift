//
//  MapClickView.swift
//  MapKitDemo
//
//  Created by ksd on 19/03/2024.
//

import SwiftUI
import MapKit

struct MapClickView: View {
    var body: some View {
        MapReader { reader in
            Map()
                .onTapGesture(perform: { screenCoord in
                    let location = reader.convert(screenCoord, from: .local)
                    print(location)
                })
        }
    }
}

#Preview {
    MapClickView()
}
