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

/// 歌曲模型
class SheetModel:HandyJSON
{
    required init() {}
    /// 歌单ID
    var id:String!;
    
    /// 歌单标题
    var title:String!
    
    /// 歌单封面
    var cover_img_url:String!
    
    /// 歌单来源url
    var source_url:String!
    
    /// 歌曲列表
    var tracks=[MusicModel]()
}
