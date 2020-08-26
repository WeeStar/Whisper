//
//  CurPlayDataService.swift
//  当前播放数据
//  Whisper
//
//  Created by WeeStar on 2020/8/26.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


/// 当前播放
class CurPlayDataService{
    //单例数据
    static var curPlayIns = GetCurPlay()
    
    /// 获取当前播放数据
    /// - Returns: 用户配置数据
    static private func GetCurPlay() -> CurPlayModel{
        //获取数据字符串
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.curPlayPath),
                                  encoding: String.Encoding.utf8)
        
        //获取数据
        if let object = CurPlayModel.deserialize(from: dataStr) {
            //空数据处理
//            //当前播放列表为空 取我的
//            if(object.curList.count==0 && ConfigDataService.contextIns.mySheets.count > 0){
//                object.curList = ConfigDataService.contextIns.mySheets[0].tracks
//            }
            if(object.curMusic==nil&&object.curList.count>0){
                object.curMusic=object.curList[0]
            }
            
            return object
        }
        
        //空数据
        return CurPlayModel()
    }
    
    
    /// 写入用户配置数据
    /// - Parameter data: 用户配置数据
    static func SaveCurPlay(){
        let contextDataStr = CurPlayDataService.curPlayIns.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.curPlayPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
}
