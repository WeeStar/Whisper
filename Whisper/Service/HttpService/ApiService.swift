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
}
