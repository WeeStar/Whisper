//
//  DataService.swift
//  数据服务
//  Whisper
//
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON


/// 数据服务
class DataService{
    
    /// 获取用户配置数据
    /// - Returns: 用户配置数据
    static func GetDataInFile() -> DataModel{
        //获取数据字符串
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.dataFilePath), encoding: String.Encoding.utf8)
        
        //获取数据
        if let object = DataModel.deserialize(from: dataStr) {
            return object
        }
        return DataModel()
    }

    
    /// 写入用户配置数据
    /// - Parameter data: 用户配置数据
    static func SetDataInFile(data:DataModel){
        
        let msg = "需要写入的资源"
        let fileName = "学习笔记.text"

        let fileManager = FileManager.default
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = file! + fileName

        fileManager.createFile(atPath: path, contents:nil, attributes:nil)

        let handle = FileHandle(forWritingAtPath:path)
        handle?.write(msg.data(using: String.Encoding.utf8)!)
    }
}

