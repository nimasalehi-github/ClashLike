////
////  GameEngine.swift
////  ClashLike
////
////  Created by Nima Salehi on 10/23/25.
////
//
//import Foundation
//import Combine
//
//// Game engine: manages grid, buildings, placement rules
//final class GameEngine: ObservableObject {
//    static var preview: GameEngine {
//        let eng = GameEngine()
//        eng.loadSampleLayout()
//        return eng
//    }
//
//    @Published var gridSize: Int = 22 // 22x22 grid as example
//    @Published var tileSize: CGFloat = 32 // for view scaling
//    @Published var buildings: [Building] = []
//    @Published var selectedType: BuildingType = .townHall
//    @Published var ghostPosition: GridPoint? = nil
//    @Published var isPlacementValid: Bool = true
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        // keep object reactive if needed
//    }
//
//    func canPlace(building: Building) -> Bool {
//        // Check bounds
//        if building.position.x < 0 || building.position.y < 0 { return false }
//        if building.position.x + building.size.width > gridSize { return false }
//        if building.position.y + building.size.height > gridSize { return false }
//
//        // Check collisions with existing buildings
//        for b in buildings {
//            if b.id == building.id { continue }
//            let setA = Set(building.occupiedPoints())
//            let setB = Set(b.occupiedPoints())
//            if !setA.intersection(setB).isEmpty {
//                return false
//            }
//        }
//        return true
//    }
//
//    func placeBuilding(type: BuildingType, at point: GridPoint) -> Bool {
//        let b = Building(type: type, position: point, size: type.defaultSize)
//        if canPlace(building: b) {
//            buildings.append(b)
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func removeBuilding(id: UUID) {
//        buildings.removeAll { $0.id == id }
//    }
//
//    func moveBuilding(id: UUID, to point: GridPoint) -> Bool {
//        guard var b = buildings.first(where: { $0.id == id }) else { return false }
//        b.position = point
//        if canPlace(building: b) {
//            if let idx = buildings.firstIndex(where: { $0.id == id }) {
//                buildings[idx] = b
//                return true
//            }
//        }
//        return false
//    }
//
//    // Export layout as JSON (prints to console for simplicity)
//    func exportLayout() {
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let data = try encoder.encode(buildings)
//            if let s = String(data: data, encoding: .utf8) {
//                print("--- Exported layout JSON ---\n\(s)")
//            }
//        } catch {
//            print("Export error: \(error)")
//        }
//    }
//
//    func loadSampleLayout() {
//        buildings = []
//        // Simple sample: center town hall
//        let center = gridSize / 2 - 1
//        _ = placeBuilding(type: .townHall, at: GridPoint(x: center, y: center))
//        _ = placeBuilding(type: .goldMine, at: GridPoint(x: center+4, y: center))
//        _ = placeBuilding(type: .cannon, at: GridPoint(x: center+1, y: center+4))
//    }
//}
// مرحلهٔ ۱ — دیباگ GameEngine.swift

// EN: Imports the Foundation framework to use basic Swift utilities like data handling, JSON encoding/decoding, and date/time.
// Data lifecycle: Foundation enables creation, storage, transformation, and reading of data, allowing it to flow between model and Views.
// OOP: Foundation is a dependency used by our class; it supports object-oriented data management.
import Foundation

import Combine

// Game engine: manages grid, buildings, placement rules
final class GameEngine: ObservableObject {
    // 1
    static var preview: GameEngine {
    // فارسی: تعریف یک property ایستا (static) به نام preview که نمونه‌ای از GameEngine را برمی‌گرداند.
    // چرخه زندگی داده‌ها: این property فقط در زمان Preview ساخته می‌شود و داده‌های نمونه را برای SwiftUI آماده می‌کند، بدون اینکه داده واقعی مدل را تغییر دهد.
    // EN: Defines a static property named 'preview' returning an instance of GameEngine.
    // Data lifecycle: This property is only created during Preview, populating sample data for SwiftUI without affecting real model data.
    // OOP: Provides a factory-like method for creating a test instance; encapsulates object creation logic.

        // 2
        let eng = GameEngine()
        // 3
        eng.loadSampleLayout()
        // 4
        return eng
    }

    // 5
    @Published var gridSize: Int = 22 // 22x22 grid as example
    // 6
    @Published var tileSize: CGFloat = 32 // for view scaling
    // 7
    @Published var buildings: [Building] = []
    // 8
    @Published var selectedType: BuildingType = .townHall
    // 9
    @Published var ghostPosition: GridPoint? = nil
    // 10
    @Published var isPlacementValid: Bool = true

    // 11
    private var cancellables = Set<AnyCancellable>()

    // 12
    init() {
        // keep object reactive if needed
    }

    // 13
    func canPlace(building: Building) -> Bool {
        // 14
        // Check bounds
        if building.position.x < 0 || building.position.y < 0 { return false }
        if building.position.x + building.size.width > gridSize { return false }
        if building.position.y + building.size.height > gridSize { return false }

        // 15
        // Check collisions with existing buildings
        for b in buildings {
            if b.id == building.id { continue }
            let setA = Set(building.occupiedPoints())
            let setB = Set(b.occupiedPoints())
            if !setA.intersection(setB).isEmpty {
                return false
            }
        }
        // 16
        return true
    }

    // 17
    func placeBuilding(type: BuildingType, at point: GridPoint) -> Bool {
        // 18
        let b = Building(type: type, position: point, size: type.defaultSize)
        // 19
        if canPlace(building: b) {
            buildings.append(b)
            return true
        } else {
            return false
        }
    }

    // 20
    func removeBuilding(id: UUID) {
        buildings.removeAll { $0.id == id }
    }

    // 21
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

    // 22
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

    // 23
    func loadSampleLayout() {
        buildings = []
        // Simple sample: center town hall
        let center = gridSize / 2 - 1
        _ = placeBuilding(type: .townHall, at: GridPoint(x: center, y: center))
        _ = placeBuilding(type: .goldMine, at: GridPoint(x: center+4, y: center))
        _ = placeBuilding(type: .cannon, at: GridPoint(x: center+1, y: center+4))
    }
}
