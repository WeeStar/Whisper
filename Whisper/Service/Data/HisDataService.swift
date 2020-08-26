//
//  HisContextService.swift
//  搜索历史数据
//  Whisper
//
//  Created by WeeStar on 2020/8/25.
//  Copyright © 2020 WeeStar. All rights reserved.
//


import Foundation

class HisDataService{
    //单例
    private static var _hisIns:HisModel?
    
    static var hisIns:HisModel{
        get{
            if(_hisIns == nil){
               //获取数据字符串
                let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.searchHisPath),
                                          encoding: String.Encoding.utf8)
                
                //获取数据
                if let his = HisModel.deserialize(from: dataStr) {
                    _hisIns = his
                }
                else{
                    _hisIns = HisModel()
                }
            }
            return _hisIns!
        }
    }
    
    /// 写入搜索历史数据
    static func AddHis(keyWords : String) -> HisModel{
        if(keyWords == ""){
            return self.hisIns
        }
        
        //去重添加
        self._hisIns?.searchHis.removeAll(where: { $0 == keyWords})
        self._hisIns?.searchHis.insert(keyWords, at: 0)
        
        //保留20个
        if(self._hisIns?.searchHis.count ?? 0 > 20){
            self._hisIns?.searchHis = Array(self._hisIns?.searchHis.prefix(upTo: 20) ?? [])
        }
        
        self.SaveHis()
        return self.hisIns
    }
    
    /// 删除搜索历史数据
    static func DelHis(keyWords : String? = nil) -> HisModel{
        if(self._hisIns?.searchHis.count == 0){
            return self.hisIns
        }
        if(keyWords == nil){
            self._hisIns?.searchHis.removeAll()
        }
        else{
            self._hisIns?.searchHis.removeAll(where: { $0 == keyWords!})
        }
        
        self.SaveHis()
        return self.hisIns
    }
    
    private static func SaveHis(){
        let contextDataStr = self.hisIns.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.searchHisPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
}
