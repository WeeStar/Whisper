//
//  ConfigModel.swift
//  用户自定义配置模型
//  Whisper
//
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

class ConfigModel: HandyJSON
{
    required init() {}
    
    /// 色彩模式 0自动 1浅色 2深色
    var colorMode:Int=0
    
    /// 是否替换当前列表
    var isReplaceCurList:Bool=true
}
