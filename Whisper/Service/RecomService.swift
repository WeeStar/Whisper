//
//  RecomService.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/1.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


/// 推荐歌单服务
class RecomService{
    static var recomSheets=[RecomModel]()//推荐歌单集合
    static var bannerSheets=[SheetModel]()
    
    
    /// 获取推荐歌单
    static func GetRecom(allCompleteHandler:(()->Void)?){
        self.recomSheets=[RecomModel]()//推荐歌单集合
        self.bannerSheets=[SheetModel]()
        
        //网易云推荐歌单
        RecomService.GetRecomSheets(source: .Netease,allCompleteHandler: allCompleteHandler)
        //QQ推荐歌单
        RecomService.GetRecomSheets(source: .Tencent,allCompleteHandler: allCompleteHandler)
        //B推荐歌单
        RecomService.GetRecomSheets(source: .Bilibili,allCompleteHandler: allCompleteHandler)
        //咪咕推荐歌单
        RecomService.GetRecomSheets(source: .Migu,allCompleteHandler: allCompleteHandler)
        //酷狗推荐歌单
        RecomService.GetRecomSheets(source: .Kugou,allCompleteHandler: allCompleteHandler)
        //虾米推荐歌单
        RecomService.GetRecomSheets(source: .Xiami,allCompleteHandler: allCompleteHandler)
    }
    
    /// 获取推荐歌单
    private static func GetRecomSheets(source:MusicSource,allCompleteHandler:(()->Void)?){
        HttpService.Get(module: "music", methodUrl: "hot_sheets", musicSource: source,params: nil,
                        successHandler: { resData in
                            //处理返回数据
                            let resArr = resData as? NSArray
                            // 空值处理
                            if(resArr == nil){
                                let recom=RecomModel()
                                recom.source=source
                                self.recomSheets.append(recom)
                                return
                            }
                            let sheets=[SheetModel].deserialize(from: resArr)
                            if(sheets == nil){
                                let recom=RecomModel()
                                recom.source=source
                                self.recomSheets.append(recom)
                                return
                            }
                            
                            //数据赋值
                            let recom=RecomModel()
                            recom.source=source
                            recom.sheets=(sheets as! [SheetModel])
                            self.recomSheets.append(recom)
                            
                            //全部请求完毕 执行后续操作
                            if(self.recomSheets.count == 6){
                                //将各家推荐第一张歌单放到banner
                                var datas = [SheetModel]()
                                for recom in self.recomSheets{
                                    if(recom.sheets.count > 0){
                                        datas.append(recom.sheets.first!)
                                    }
                                }
                                self.bannerSheets=datas
                                
                                //执行全部完成通知
                                allCompleteHandler?()
                            }
        },
                        failHandler: {errorMsg in
                            //接口请求错误
                            let recom=RecomModel()
                            recom.source=source
                            self.recomSheets.append(recom)
        })
    }
}

class RecomModel{
    var source=MusicSource.Unknow
    
    /// 歌单列表
    var sheets=[SheetModel]()
}

extension RecomModel: Hashable {
    static func == (lhs: RecomModel, rhs: RecomModel) -> Bool {
        return lhs.source == rhs.source
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(source)
    }
}
