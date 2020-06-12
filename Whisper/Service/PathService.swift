//
//  PathService.swift
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation

class PathService{
    
    private static var _documentDir:String?
    
    /// Document文件夹
    static var documentDir:String{
        get{
            if(_documentDir == nil){
                _documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            }
            return _documentDir!
        }
    }
    
    
    
    private static var _cacheDir:String?
    
    /// Cache文件夹
    static var cacheDir:String{
        get{
            if(_cacheDir == nil){
                _cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            }
            return _cacheDir!
        }
    }
    
    
    
    /// 用户数据文件
    static var dataFilePath:String{
        get{
            return self.documentDir + "/UserData.json"
        }
    }
}
