//
//  Common.swift
//  通用信息
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


/// 当前信息
class Common
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


