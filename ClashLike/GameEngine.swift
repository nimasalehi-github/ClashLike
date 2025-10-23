//
//  GameEngine.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import Foundation
import Foundation
import Combine

// Game engine: manages grid, buildings, placement rules
final class GameEngine: ObservableObject {
    static var preview: GameEngine {
        let eng = GameEngine()
        eng.loadSampleLayout()
        return eng
    }

    @Published var gridSize: Int = 22 // 22x22 grid as example
    @Published var tileSize: CGFloat = 32 // for view scaling
    @Published var buildings: [Building] = []
    @Published var selectedType: BuildingType = .townHall
    @Published var ghostPosition: GridPoint? = nil
    @Published var isPlacementValid: Bool = true

    private var cancellables = Set<AnyCancellable>()

    init() {
        // keep object reactive if needed
    }

    func canPlace(building: Building) -> Bool {
        // Check bounds
        if building.position.x < 0 || building.position.y < 0 { return false }
        if building.position.x + building.size.width > gridSize { return false }
        if building.position.y + building.size.height > gridSize { return false }

        // Check collisions with existing buildings
        for b in buildings {
            if b.id == building.id { continue }
            let setA = Set(building.occupiedPoints())
            let setB = Set(b.occupiedPoints())
            if !setA.intersection(setB).isEmpty {
                return false
            }
        }
        return true
    }

    func placeBuilding(type: BuildingType, at point: GridPoint) -> Bool {
        let b = Building(type: type, position: point, size: type.defaultSize)
        if canPlace(building: b) {
            buildings.append(b)
            return true
        } else {
            return false
        }
    }

    func removeBuilding(id: UUID) {
        buildings.removeAll { $0.id == id }
    }

    func moveBuilding(id: UUID, to point: GridPoint) -> Bool {
        guard var b = buildings.first(where: { $0.id == id }) else { return false }
        b.position = point
        if canPlace(building: b) {
            if let idx = buildings.firstIndex(where: { $0.id == id }) {
                buildings[idx] = b
                return true
            }
        }
        return false
    }

    // Export layout as JSON (prints to console for simplicity)
    func exportLayout() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(buildings)
            if let s = String(data: data, encoding: .utf8) {
                print("--- Exported layout JSON ---\n\(s)")
            }
        } catch {
            print("Export error: \(error)")
        }
    }

    func loadSampleLayout() {
        buildings = []
        // Simple sample: center town hall
        let center = gridSize / 2 - 1
        _ = placeBuilding(type: .townHall, at: GridPoint(x: center, y: center))
        _ = placeBuilding(type: .goldMine, at: GridPoint(x: center+4, y: center))
        _ = placeBuilding(type: .cannon, at: GridPoint(x: center+1, y: center+4))
    }
}
