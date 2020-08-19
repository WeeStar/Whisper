//
//  UserDataModel.swift
//  总体数据
//  Whisper
//
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

/// 上下文总体模型
class ContextModel: HandyJSON
{
    required init() {}
    
    /// 用户数据
    var userInfo:UserModel?
    
    /// 配置信息
    var config:ConfigModel=ConfigModel()
    
    /// 我的歌单
    var mySheets=[SheetModel]()
    
    /// 最近播放列表集合
    var recentSheets=[SheetModel]()
    
    /// 当前歌曲信息
    var curMusic:CurMusicModel=CurMusicModel()
}

/// 搜索历史模型
class SearchHisModel: HandyJSON
{
    required init() {}
    
    /// 搜索结果歌单
    var hisList=[String]()
}
