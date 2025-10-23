//
//  ContentView.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var engine: GameEngine

    var body: some View {
        NavigationView {
            ZStack {
                MapView()
                    .environmentObject(engine)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    HUDView()
                        .environmentObject(engine)
                        .padding()
                }
            }
            .navigationTitle("FortressGrid")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { engine.exportLayout() }) {
                        Text("Export")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { engine.loadSampleLayout() }) {
                        Text("Sample")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameEngine.preview)
    }
}
