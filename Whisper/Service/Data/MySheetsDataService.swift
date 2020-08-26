//
//  MySheetsDataService.swift
//  我的歌单数据
//  Whisper
//
//  Created by WeeStar on 2020/8/26.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


class MySheetsDataService: ObservableObject{
    var mySheetsData:MySheetsModel
    @Published var mySheets:[SheetModel]
    @Published var favSheets:[SheetModel]
    
    //单例
    static var shareIns = MySheetsDataService()
    
    /// 初始化
    private init(){
        //获取数据字符串
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.mySheetsPath),
                                  encoding: String.Encoding.utf8)
        
        //获取数据
        if let ins = MySheetsModel.deserialize(from: dataStr) {
            self.mySheetsData = ins
            self.mySheets = ins.mySheets
            self.favSheets = ins.favSheets
        }
        else{
            self.mySheetsData = MySheetsModel()
            self.mySheets = [SheetModel]()
            self.favSheets = [SheetModel]()
        }
    }
    
    
    
    
    /// 新增我的歌单
    func AddMySheets(sheet : SheetModel){
        if(sheet == SheetModel()){
            return
        }
        
        //新增歌单
        self.mySheetsData.mySheets.removeAll(where: { $0.id == sheet.id})
        self.mySheetsData.mySheets.insert(sheet, at: 0)
        self.mySheets = self.mySheetsData.mySheets
        self.SaveMySheets()
    }
    
    /// 更新我的歌单信息
    func UpdateMySheets(sheet : SheetModel) -> Bool{
        if(sheet == SheetModel()){
            return false
        }
        
        //校验
        let mySheet = self.mySheetsData.mySheets.first(where: { $0.id == sheet.id})
        if(mySheet == nil){
            return false
        }
        
        //更新歌单
        mySheet!.title = sheet.title
        mySheet!.description = sheet.description
        mySheet!.cover_img_url = sheet.cover_img_url
        mySheet!.ori_cover_img_url = sheet.ori_cover_img_url
        
        self.mySheets = self.mySheetsData.mySheets
        self.SaveMySheets()
        return true
    }
    
    /// 更新我的歌单信息
    func InsertMusicMySheets(sheetId : String ,music:MusicModel) -> Bool{
        if(music == MusicModel()){
            return false
        }
        
        //校验
        let mySheet = self.mySheetsData.mySheets.first(where: { $0.id == sheetId})
        if(mySheet == nil){
            return false
        }
        if(mySheet!.tracks.firstIndex(where: { $0.id == music.id }) != nil){
            return true
        }
        
        //插入歌曲
        mySheet!.tracks.insert(music, at: 0)
        self.mySheets = self.mySheetsData.mySheets
        self.SaveMySheets()
        return true
    }
    
    /// 删除我的歌单
    func DelMySheets(id : String){
        self.mySheetsData.mySheets.removeAll(where: { $0.id == id})
        self.mySheets = self.mySheetsData.mySheets
        self.SaveMySheets()
    }
    
    
    /// 新增收藏歌单
    func AddFavSheets(sheet : SheetModel){
        if(sheet == SheetModel()){
            return
        }
        
        //新增歌单
        sheet.tracks = [MusicModel]()//置空歌曲内容
        self.mySheetsData.favSheets.removeAll(where: { $0.id == sheet.id})
        self.mySheetsData.favSheets.insert(sheet, at: 0)
        self.favSheets = self.mySheetsData.favSheets
        self.SaveMySheets()
    }
    
    /// 删除收藏歌单
    func DelFavSheets(id : String){
        self.mySheetsData.favSheets.removeAll(where: { $0.id == id})
        self.favSheets = self.mySheetsData.favSheets
        self.SaveMySheets()
    }
    
    private func SaveMySheets(){
        let contextDataStr = self.mySheetsData.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.mySheetsPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
}
