//
//  Common.swift
//  用户数据信息
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


/// 用户数据信息
class StoreData
{
    private static var _contextInfo:DataModel?
    
    /// 当前上下文信息
    static var contextInfo:DataModel
    {
        get{
            if(_contextInfo == nil){
                _contextInfo = DataService.GetDataInFile()
            }
            return _contextInfo!
        }
        set{
            _contextInfo = newValue
        }
    }
}


