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
    
    /// 当前歌曲信息
    var curMusic:CurMusicModel=CurMusicModel()
}
    
