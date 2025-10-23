//
//  MapView.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import Foundation
import SwiftUI

struct MapView: View {
    @EnvironmentObject var engine: GameEngine
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            let total = CGFloat(engine.gridSize) * engine.tileSize
            ZStack(alignment: .topLeading) {
                // Background grid
                Path { path in
                    for i in 0...engine.gridSize {
                        let pos = CGFloat(i) * engine.tileSize
                        // vertical
                        path.move(to: CGPoint(x: pos, y: 0))
                        path.addLine(to: CGPoint(x: pos, y: total))
                        // horizontal
                        path.move(to: CGPoint(x: 0, y: pos))
                        path.addLine(to: CGPoint(x: total, y: pos))
                    }
                }
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)

                // Existing buildings
                ForEach(engine.buildings) { b in
                    BuildingView(building: b)
                        .environmentObject(engine)
                        .position(x: CGFloat(b.position.x) * engine.tileSize + CGFloat(b.size.width) * engine.tileSize / 2,
                                  y: CGFloat(b.position.y) * engine.tileSize + CGFloat(b.size.height) * engine.tileSize / 2)
                }

                // Ghost for placement
                if let ghost = engine.ghostPosition {
                    let sizeW = CGFloat(engine.selectedType.defaultSize.width) * engine.tileSize
                    let sizeH = CGFloat(engine.selectedType.defaultSize.height) * engine.tileSize
                    Rectangle()
                        .fill(engine.isPlacementValid ? Color.green.opacity(0.35) : Color.red.opacity(0.35))
                        .frame(width: sizeW, height: sizeH)
                        .position(x: CGFloat(ghost.x) * engine.tileSize + sizeW/2,
                                  y: CGFloat(ghost.y) * engine.tileSize + sizeH/2)
                }
            }
            .frame(width: total, height: total)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        let local = val.location
                        let gx = Int((local.x / engine.tileSize).rounded(.down))
                        let gy = Int((local.y / engine.tileSize).rounded(.down))
                        engine.ghostPosition = GridPoint(x: gx, y: gy)
                        let ghostBuilding = Building(type: engine.selectedType, position: GridPoint(x: gx, y: gy), size: engine.selectedType.defaultSize)
                        engine.isPlacementValid = engine.canPlace(building: ghostBuilding)
                    }
                    .onEnded { val in
                        if let ghost = engine.ghostPosition {
                            if engine.placeBuilding(type: engine.selectedType, at: ghost) {
                                // placed
                            } else {
                                // cannot place
                            }
                        }
                        engine.ghostPosition = nil
                    }
            )
            .padding()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(GameEngine.preview)
    }
}

