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
    
    /// 循环模式
    var roundMode=RoundModeEnum.ListRound
}


/// 循环类型枚举
enum RoundModeEnum:Int, HandyJSONEnum
{
    case ListRound=1
    case RandomRound=2
    case SingleRound=3
}
