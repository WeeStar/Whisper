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
    
    /// 获取上下文总体数据
    /// - Returns: 用户配置数据
    static func GetContext() -> ContextModel{
        //获取数据字符串
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.userDataPath),
                                  encoding: String.Encoding.utf8)
        
        //获取数据
        if let object = ContextModel.deserialize(from: dataStr) {
            
            //部分空数据处理
            if(object.curMusic.curList.count==0 && object.mySheets.count > 0){
                object.curMusic.curList=object.mySheets[0].tracks
            }
            if(object.curMusic.curMusic==nil&&object.curMusic.curList.count>0){
                object.curMusic.curMusic=object.curMusic.curList[0]
            }
            
            return object
        }
        
        //空数据
        return ContextModel()
    }

    
    /// 写入用户配置数据
    /// - Parameter data: 用户配置数据
    static func SaveContext(data:ContextModel){
        let contextDataStr = data.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.userDataPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
}

