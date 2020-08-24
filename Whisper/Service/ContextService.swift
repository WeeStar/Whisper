//
//  ContextService.swift
//  上下文服务
//  Whisper
//
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON


/// 上下文服务
class ContextService{
    
    static var musicSourcSeq=[MusicSource.Netease,MusicSource.Tencent,MusicSource.Xiami,
                              MusicSource.Migu,MusicSource.Kugou,MusicSource.Bilibili]
    
    //单例上下文数据
    static var contextIns = GetContext()
    
    
    /// 获取上下文总体数据
    /// - Returns: 用户配置数据
    static private func GetContext() -> ContextModel{
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
    static func SaveContext(){
        let contextDataStr = ContextService.contextIns.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.userDataPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
    
    
    
    private static var _searchHis:SearchHisModel?
    static var hisIns:SearchHisModel {
        get{
            if(_searchHis == nil){
                _searchHis = GetHis()
            }
            return _searchHis!
        }
    }
    
    
    /// 获取上下文总体数据
    /// - Returns: 用户配置数据
    static private func GetHis() -> SearchHisModel{
        //获取数据字符串
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.searchHisPath),
                                  encoding: String.Encoding.utf8)
        
        //获取数据
        if let his = SearchHisModel.deserialize(from: dataStr) {
            return his
        }
        
        //空数据
        return SearchHisModel()
    }
    
    
    /// 写入搜索历史数据
    static func AddHis(keyWords : String) -> [String]{
        if(keyWords == ""){
            return self.hisIns.hisList
        }
        
        self._searchHis!.hisList.removeAll(where: { $0 == keyWords})
        self._searchHis!.hisList.insert(keyWords, at: 0)
        if(self._searchHis!.hisList.count > 20){
            self._searchHis!.hisList = Array(self._searchHis!.hisList.prefix(upTo: 20))
        }
        
        let contextDataStr = self._searchHis!.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.searchHisPath)!, atomically: false, encoding: String.Encoding.utf8)
        
        return self.hisIns.hisList
    }
    
    
    /// 删除搜索历史数据
    static func DelHis(keyWords : String? = nil) -> [String]{
        if(self._searchHis == nil){
            return [String]()
        }
        if(keyWords == nil){
            self._searchHis!.hisList = [String]()
        }
        else{
            self._searchHis!.hisList.removeAll(where: { $0 == keyWords!})
        }
        
        let contextDataStr = self._searchHis!.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.searchHisPath)!, atomically: false, encoding: String.Encoding.utf8)
        
        return self.hisIns.hisList
    }
}
