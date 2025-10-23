//
//  Models.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import Foundation
import Foundation
import CoreGraphics

// Simple building model
struct Building: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var type: BuildingType
    var position: GridPoint // top-left grid coordinate
    var size: Size // in grid units (width, height)
    var rotation: Int = 0 // 0,90,180,270

    // Helper to get occupied points
    func occupiedPoints() -> [GridPoint] {
        var points: [GridPoint] = []
        for x in 0..<size.width {
            for y in 0..<size.height {
                points.append(GridPoint(x: position.x + x, y: position.y + y))
            }
        }
        return points
    }
}

enum BuildingType: String, Codable {
    case townHall, goldMine, cannon, wall, barracks, archerTower

    var displayName: String {
        switch self {
        case .townHall: return "Town Hall"
        case .goldMine: return "Gold Mine"
        case .cannon: return "Cannon"
        case .wall: return "Wall"
        case .barracks: return "Barracks"
        case .archerTower: return "Archer Tower"
        }
    }

    var defaultSize: Size {
        switch self {
        case .townHall: return Size(width: 3, height: 3)
        case .goldMine: return Size(width: 2, height: 2)
        case .cannon: return Size(width: 2, height: 2)
        case .wall: return Size(width: 1, height: 1)
        case .barracks: return Size(width: 3, height: 2)
        case .archerTower: return Size(width: 2, height: 2)
        }
    }
}

struct Size: Codable, Equatable {
    var width: Int
    var height: Int
}

struct GridPoint: Codable, Hashable, Equatable {
    var x: Int
    var y: Int
}
