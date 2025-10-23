//
//  ClashLikeApp.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import SwiftUI

@main
struct ClashLikeApp: App {
    @StateObject private var engine = GameEngine()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(engine)
        }
    }
}
