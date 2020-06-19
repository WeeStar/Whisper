//
//  IconTextView.swift
//  IconFont图标
//  Whisper
//
//  Created by WeeStar on 2020/6/18.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// IconFont图标
struct IconTextView: View {
    private var iconCode: String
    private var size: CGFloat
    private var weight:Font.Weight
    
    /// 解码
    private func unicodeString() -> String {
        let rawMutable = NSMutableString(string: "\\u\(self.iconCode)")
        CFStringTransform(rawMutable, nil, "Any-Hex/Java" as NSString, true)
        return rawMutable as String
    }
    
    /// IconFont图标
    /// - Parameters:
    ///   - iconCode: 图标编码 类似 &#xe613;
    ///   - size: 字号
    ///   - weight: 字重
    public init(iconCode: String, size: CGFloat, weight: Font.Weight? = nil) {
        self.size = size
        self.weight = weight ?? .regular
        
        //处理图标编码
        self.iconCode  = iconCode.hasPrefix("&#x") ? String(iconCode.dropFirst(3)) : iconCode
        self.iconCode = self.iconCode.hasSuffix(";") ? String(self.iconCode.dropLast(1)) : self.iconCode
    }
    
    var body: some View {
        Text(unicodeString())
            .font(Font.custom("iconfont", size: self.size))
            .fontWeight(self.weight)
    }
}

struct IconTextView_Previews: PreviewProvider {
    static var previews: some View {
        IconTextView(iconCode: "&#xe613", size: 14.0)
    }
}
