//
//  HisContextService.swift
//  搜索历史数据
//  Whisper
//
//  Created by WeeStar on 2020/8/25.
//  Copyright © 2020 WeeStar. All rights reserved.
//


import Foundation


class HisDataService: ObservableObject{
    var hisData:HisModel
    @Published var searchHis:[String]
    @Published var hisSheets:[SheetModel]
    
    
    //单例
    static var shareIns = HisDataService()
    
    /// 初始化
    private init(){
        let dataStr = try? String(contentsOf: URL.init(fileURLWithPath: PathService.searchHisPath),
                                  encoding: String.Encoding.utf8)
        
        //获取数据
        if let his = HisModel.deserialize(from: dataStr) {
            self.hisData = his
            self.searchHis = his.searchHis
            self.hisSheets = his.playSheetHis
        }
        else{
            self.hisData = HisModel()
            self.searchHis = [String]()
            self.hisSheets = [SheetModel]()
        }
    }
    
    /// 写入搜索历史数据
    func AddHis(keyWords : String){
        if(keyWords == ""){
            return
        }
        
        //去重添加
        self.hisData.searchHis.removeAll(where: { $0 == keyWords})
        self.hisData.searchHis.insert(keyWords, at: 0)
        
        //保留20个
        if(self.hisData.searchHis.count > 20){
            self.hisData.searchHis = Array(self.hisData.searchHis.prefix(upTo: 20))
        }
        DispatchQueue.main.async {
            self.searchHis = self.hisData.searchHis
        }
        
        self.SaveHis()
    }
    
    /// 删除搜索历史数据
    func DelHis(keyWords : String? = nil){
        if(self.hisData.searchHis.count == 0){
            return
        }
        if(keyWords == nil){
            self.hisData.searchHis.removeAll()
        }
        else{
            self.hisData.searchHis.removeAll(where: { $0 == keyWords!})
        }
        DispatchQueue.main.async {
            self.searchHis = self.hisData.searchHis
        }
        
        self.SaveHis()
    }
    
    private func SaveHis(){
        let contextDataStr = self.hisData.toJSONString()!
        try! contextDataStr.write(to: URL(string:"file://" + PathService.searchHisPath)!, atomically: false, encoding: String.Encoding.utf8)
    }
    
    /// 写入歌单播放历史数据
    func AddSheetHis(sheet : SheetModel){
        if(sheet == SheetModel()){
            return
        }
        
        //拷贝对象 避免置空歌曲影响
        let handleSheet = SheetModel.deserialize(from: sheet.toJSONString())
        
        //去重添加
        handleSheet!.tracks = [MusicModel]()//置空歌曲内容
        self.hisData.playSheetHis.removeAll(where: { $0.id == handleSheet!.id})
        self.hisData.playSheetHis.insert(handleSheet!, at: 0)
        
        //保留8个
        if(self.hisData.searchHis.count > 8){
            self.hisData.searchHis = Array(self.hisData.searchHis.prefix(upTo: 8))
        }
        
        DispatchQueue.main.async {
            self.hisSheets = self.hisData.playSheetHis
        }
        
        self.SaveHis()
    }
    
    /// 删除歌单播放历史数据
    func DelSheetHis(sheetId : String){
        
        self.hisData.playSheetHis.removeAll(where: { $0.id == sheetId})
        DispatchQueue.main.async {
            self.hisSheets = self.hisData.playSheetHis
        }
        
        self.SaveHis()
    }
}
