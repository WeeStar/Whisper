//
//  Sheet.swift
//  歌单模型
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

/// 歌单模型
class SheetModel:HandyJSON, Identifiable
{
    required init() {}
    /// 歌单ID
    var id:String!
    
    /// 歌单标题
    var title:String!
    
    var description:String!
    
    var play:String! = "0"
    
    var sheet_source:MusicSource!
    
    /// 歌单封面
    var cover_img_url:String!
    var ori_cover_img_url:String!
    
    /// 歌单来源url
    var source_url:String!
    
    /// 歌曲列表
    var tracks=[MusicModel]()
}


extension SheetModel: Hashable {
    static func == (lhs: SheetModel, rhs: SheetModel) -> Bool {
        return lhs.source_url == rhs.source_url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(source_url)
    }
}


extension RandomAccessCollection where Self.Element: Identifiable {
    func isThresholdItem<Item: Identifiable>(offset: Int,
                                             item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = firstIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        let offset = offset < count ? offset : count - 1
        return offset == (distance - 1)
    }
}
