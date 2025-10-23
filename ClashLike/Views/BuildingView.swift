//
//  BuildingView.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import Foundation
import SwiftUI

struct BuildingView: View {
    @EnvironmentObject var engine: GameEngine
    let building: Building

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(colorForType(building.type))
                .frame(width: CGFloat(building.size.width) * engine.tileSize,
                       height: CGFloat(building.size.height) * engine.tileSize)
                .overlay(
                    Text(building.type.displayName)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4),
                    alignment: .bottom
                )
                .shadow(radius: 2)
        }
        .onTapGesture(count: 2) {
            // double-tap to remove
            engine.removeBuilding(id: building.id)
        }
    }

    private func colorForType(_ t: BuildingType) -> Color {
        switch t {
        case .townHall: return Color.blue
        case .goldMine: return Color.yellow
        case .cannon: return Color.gray
        case .wall: return Color.brown
        case .barracks: return Color.purple
        case .archerTower: return Color.orange
        }
    }
}
