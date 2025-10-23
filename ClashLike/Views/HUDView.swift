//
//  HUDView.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import Foundation
import SwiftUI

struct HUDView: View {
    @EnvironmentObject var engine: GameEngine

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ForEach([BuildingType.townHall, .goldMine, .cannon, .wall, .barracks, .archerTower], id: \ .self) { t in
                    Button(action: { engine.selectedType = t }) {
                        VStack {
                            Text(t.displayName)
                                .font(.footnote)
                            Text("\(t.defaultSize.width)x\(t.defaultSize.height)")
                                .font(.caption2)
                        }
                        .padding(8)
                        .background(engine.selectedType == t ? Color.accentColor.opacity(0.9) : Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                        .frame(minWidth: 70)
                    }
                }
            }
            HStack {
                Button(action: { engine.buildings.removeAll() }) {
                    Text("Clear")
                        .bold()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: { engine.exportLayout() }) {
                    Text("Export JSON")
                        .bold()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(BlurView(style: .systemThinMaterial))
        .cornerRadius(12)
    }
}

struct HUDView_Previews: PreviewProvider {
    static var previews: some View {
        HUDView()
            .environmentObject(GameEngine.preview)
    }
}
