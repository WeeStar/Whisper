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
    
    var sheet_source:String!
    
    /// 歌单封面
    var cover_img_url:String!
    
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
