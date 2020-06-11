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

/// 总体数据模型
class DataModel: HandyJSON
{
    required init() {}
    
    /// 用户数据
    var userInfo:UserModel?
    
    /// 配置信息
    var config:ConfigModel?
    
    /// 我的歌单
    var mySheets=[SheetModel]()
    
    /// 当前歌曲信息
    var curMusic:CurMusicModel?
}
    