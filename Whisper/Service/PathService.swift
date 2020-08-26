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
    
    /// 用户配置路径
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
    
    
    
    private static var _curPlayPath:String?
    
    /// 当前播放数据文件路径
    static var curPlayPath:String{
        get{
            if(_curPlayPath == nil){
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let curPlayPath = dir.appendingPathComponent("CurPlay.json").path
                    
                    // 文件夹不存在则创建
                    let fileManager = FileManager.default
                    if(!fileManager.fileExists(atPath: curPlayPath)){
                        fileManager.createFile(atPath: curPlayPath,contents: nil)
                    }
                    _curPlayPath = curPlayPath
                }
            }
            return _curPlayPath!
        }
    }
    
    
    
    private static var _searchHisPath:String?
    
    /// 搜索历史文件路径
    static var searchHisPath:String{
        get{
            if(_searchHisPath == nil){
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let searchHisPath = dir.appendingPathComponent("SearchHis.json").path
                    
                    // 文件夹不存在则创建
                    let fileManager = FileManager.default
                    if(!fileManager.fileExists(atPath: searchHisPath)){
                        fileManager.createFile(atPath: searchHisPath,contents: nil)
                    }
                    _searchHisPath = searchHisPath
                }
            }
            return _searchHisPath!
        }
    }
    
    
    private static var _mySheetsPath:String?
    
    /// 搜索历史文件路径
    static var mySheetsPath:String{
        get{
            if(_mySheetsPath == nil){
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let mySheetsPath = dir.appendingPathComponent("MySheets.json").path
                    
                    // 文件夹不存在则创建
                    let fileManager = FileManager.default
                    if(!fileManager.fileExists(atPath: mySheetsPath)){
                        fileManager.createFile(atPath: mySheetsPath,contents: nil)
                    }
                    _mySheetsPath = mySheetsPath
                }
            }
            return _mySheetsPath!
        }
    }
}
