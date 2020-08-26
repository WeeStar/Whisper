//
//  ApiService.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation

/// 接口服务
class ApiService{
    /// 获取歌单信息
    static func GetSheetInfo(source:MusicSource,sheetId:String,completeHandler:((SheetModel) -> Void)? ){
        HttpService.Get(module: "music", methodUrl: "sheet_info", musicSource: source,params: ["sheet_id":sheetId],
                        successHandler: { resData in
                            // 空值处理
                            if(resData == nil){
                                return
                            }
                            let sheetInfo=SheetModel.deserialize(from: resData as? NSDictionary)
                            if(sheetInfo == nil){
                                return
                            }
                            
                            //歌单赋值
                            completeHandler?(sheetInfo!)
        },
                        failHandler: {errorMsg in
                            return
        })
    }
    
    /// 获取歌单信息
    static func SearchMusic(source:MusicSource,searchKeyWords:String,completeHandler:(([MusicModel]) -> Void)? ){
        HttpService.Get(module: "music", methodUrl: "search", musicSource: source,params: ["key_words":searchKeyWords],
                        successHandler: { resData in
                            //处理返回数据
                            var resMusics = [MusicModel]()
                            let resArr = resData as? NSArray
                            // 空值处理
                            if(resArr == nil){
                                resMusics = [MusicModel]()
                                completeHandler?(resMusics)
                            }
                            let musics=[MusicModel].deserialize(from: resArr)
                            if(musics == nil){
                                resMusics = [MusicModel]()
                            }
                            else{
                                resMusics = musics as! [MusicModel]
                            }
                            completeHandler?(resMusics)
        },
                        failHandler: {errorMsg in
                            return
        })
    }
}
