//
//  MySheetsDataService.swift
//  我的歌单数据
//  Whisper
//
//  Created by WeeStar on 2020/8/26.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation

class MySheetsDataService{
    //单例
    private static var _mySheetsIns:MySheetsModel?
    
    static var mySheetsIns:MySheetsModel{
        get{
            if(_mySheetsIns == nil){
               //获取数据字符串
                let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.searchHisPath),
                                          encoding: String.Encoding.utf8)
                
                //获取数据
                if let ins = MySheetsModel.deserialize(from: dataStr) {
                    _mySheetsIns = ins
                }
                else{
                    _mySheetsIns = MySheetsModel()
                }
            }
            return _mySheetsIns!
        }
    }
    
    
    /// 新增我的歌单
    static func AddMySheets(sheet : SheetModel){
        if(sheet == SheetModel()){
            return
        }
        
        //新增歌单
        self._mySheetsIns?.mySheets.removeAll(where: { $0.id == sheet.id})
        self._mySheetsIns?.mySheets.insert(sheet, at: 0)
        self.SaveMySheets()
    }
    
    /// 更新我的歌单信息
    static func UpdateMySheets(sheet : SheetModel) -> Bool{
        if(sheet == SheetModel()){
            return false
        }
        
        //校验
        let mySheet = self._mySheetsIns?.mySheets.first(where: { $0.id == sheet.id})
        if(mySheet == nil){
            return false
        }
        
        //更新歌单
        mySheet!.title = sheet.title
        mySheet!.description = sheet.description
        mySheet!.cover_img_url = sheet.cover_img_url
        mySheet!.ori_cover_img_url = sheet.ori_cover_img_url
        
        self.SaveMySheets()
        return true
    }
    
    /// 更新我的歌单信息
    static func InsertMusicMySheets(sheetId : String ,music:MusicModel) -> Bool{
        if(music == MusicModel()){
            return false
        }
        
        //校验
        let mySheet = self._mySheetsIns?.mySheets.first(where: { $0.id == sheetId})
        if(mySheet == nil){
            return false
        }
        if(mySheet!.tracks.firstIndex(where: { $0.id == music.id }) != nil){
            return true
        }
        
        //插入歌曲
        mySheet!.tracks.insert(music, at: 0)
        self.SaveMySheets()
        return true
    }
    
    /// 删除我的歌单
    static func DelMySheets(id : String){
        self._mySheetsIns?.mySheets.removeAll(where: { $0.id == id})
        self.SaveMySheets()
    }
    
    
    /// 新增收藏歌单
    static func AddFavSheets(sheet : SheetModel){
        if(sheet == SheetModel()){
            return
        }
        
        //新增歌单
        sheet.tracks = [MusicModel]()//置空歌曲内容
        self._mySheetsIns?.favSheets.removeAll(where: { $0.id == sheet.id})
        self._mySheetsIns?.favSheets.insert(sheet, at: 0)
        self.SaveMySheets()
    }
    
    /// 删除收藏歌单
    static func DelFavSheets(id : String){
        self._mySheetsIns?.favSheets.removeAll(where: { $0.id == id})
        self.SaveMySheets()
    }
    
    private static func SaveMySheets(){
        let contextDataStr = self.mySheetsIns.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.mySheetsPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
}
