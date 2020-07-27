//
//  PathService.swift
//  路径服务
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


/// 路径服务
class PathService{
    
    private static var _musicCacheDir:String?
    
    /// 音乐缓存文件夹
    static var musicCacheDir:String{
        get{
            if(_musicCacheDir == nil){
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let cacheDir = dir.appendingPathComponent("MusicCache").path
                    
                    // 文件夹不存在则创建
                    let fileManager = FileManager.default
                    if(!fileManager.fileExists(atPath: cacheDir)){
                        try! fileManager.createDirectory(atPath: cacheDir, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    _musicCacheDir = cacheDir
                }
            }
            return _musicCacheDir!
        }
    }
    
    
    private static var _userDataPath:String?
    
    /// 用户数据文件路径
    static var userDataPath:String{
        get{
           if(_userDataPath == nil){
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let userDataPath = dir.appendingPathComponent("UserData.json").path
                
                // 文件夹不存在则创建
                let fileManager = FileManager.default
                if(!fileManager.fileExists(atPath: userDataPath)){
                    fileManager.createFile(atPath: userDataPath,contents: nil)
                }
                _userDataPath = userDataPath
            }
           }
           return _userDataPath!
        }
    }
}
