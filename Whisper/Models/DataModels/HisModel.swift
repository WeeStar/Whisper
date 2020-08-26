//
//  HisModel.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/26.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON


/// 历史模型
class HisModel: HandyJSON
{
    required init() {}
    
    /// 搜索历史
    var searchHis=[String]()
    
    /// 歌单播放历史
    var playSheetHis = [SheetModel]()
}
