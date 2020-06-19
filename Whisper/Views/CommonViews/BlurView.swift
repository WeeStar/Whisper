//
//  BlurView.swift
//  Whisper
//
//  Created by WeeStar on 2020/6/19.
//  Copyright © 2020 WeeStar. All rights reserved.
//


import SwiftUI

public struct BlurView: UIViewRepresentable {
    public var style: UIBlurEffect.Style
    
    public init(_ style: UIBlurEffect.Style, cornerRadius: CGFloat? = nil) {
        self.style = style
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//        if let cornerRadius = self.cornerRadius {
//            uiView.clipsToBounds = true
//            uiView.layer.cornerRadius = cornerRadius
//        }
    }
}
