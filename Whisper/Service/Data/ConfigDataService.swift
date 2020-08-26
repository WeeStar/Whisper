//
//  ConfigDataService.swift
//  配置数据
//  Whisper
//
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation

class ConfigDataService{
    
    //单例
    static var configIns = GetConfig()
    
    /// 获取配置数据
    static private func GetConfig() -> ConfigModel{
        //获取数据字符串
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.userDataPath),
                                  encoding: String.Encoding.utf8)
        
        //获取数据
        if let object = ConfigModel.deserialize(from: dataStr) {
            return object
        }
        
        //空数据
        return ConfigModel()
    }
    
    
    /// 写入配置数据
    /// - Parameter data: 用户配置数据
    static func SaveConfig(){
        let contextDataStr = ConfigDataService.configIns.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.userDataPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
}
