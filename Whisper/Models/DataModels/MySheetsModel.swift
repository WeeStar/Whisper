//
//  MySheetsModel.swift
//  我的歌单模型
//  Whisper
//
//  Created by WeeStar on 2020/8/26.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

/// 我的歌单模型
class MySheetsModel: HandyJSON
{
    required init() {}
    
    /// 我的歌单
    var mySheets=[SheetModel]()
    
    /// 收藏歌单
    var favSheets=[SheetModel]()
}


