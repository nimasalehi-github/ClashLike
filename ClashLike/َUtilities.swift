//
//  َUtilities.swift
//  ClashLike
//
//  Created by Nima Salehi on 10/23/25.
//

import Foundation
import SwiftUI
import UIKit

// Small UIKit wrapper to get blur backgrounds in SwiftUI
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
