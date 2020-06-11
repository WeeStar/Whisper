//
//  CurMusicModel.swift
//  当前音乐信息
//  Whisper
//
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

/// 当前音乐信息模型
class CurMusicModel: HandyJSON
{
    required init() {}
    
    /// 当前音乐列表
    var curList=[MusicModel]()
    
    /// 当前音乐
    var curMusic:MusicModel?
    
    /// 当前音乐时间
    var curMusicTime:String?
    
    /// 循环模式 1列表 2列表循环 2随机 3单曲循环
    var roundMode=1
    
    /// 最近播放列表集合
    var recentSheets=[SheetModel]()
}
