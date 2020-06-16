//
//  MusicModel.swift
//  歌曲模型
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

/// 歌曲模型
class MusicModel:HandyJSON, Identifiable
{
    required init() {}
    
    /// 歌曲ID
    var id:String!
    
    /// 歌曲标题
    var title:String!
    
    /// 艺术家名称
    var artist:String?
    
    /// 艺术家ID
    var artist_id:String?
    
    /// 专辑
    var album:String?
    
    /// 专辑ID
    var album_id:String?
    
    /// 来源(QQ、网易云等)
    var source:MusicSource!
    
    /// 来源url
    var source_url:String!
    
    /// url
    var url:String!
    
    /// 音乐封面
    var img_url:String!
    
    /// 所属歌单ID
    var sheet_id:String?
    
    /// 获取歌曲描述（艺术家 - 专辑）
    /// - Returns: 歌曲描述
    func getDesc() -> String {
        var desc = self.artist ?? ""
        if(self.album != nil){
            desc.append(" - " + self.album!)
        }
        return desc
    }
    
    /// 歌曲播放
    func play()
    {
        //播放
        print("播放歌曲："+self.title)
    }
}


extension MusicModel: Hashable {
    static func == (lhs: MusicModel, rhs: MusicModel) -> Bool {
        return lhs.source_url == rhs.source_url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(source_url)
    }
}

/// 音乐来源枚举
enum MusicSource:String, HandyJSONEnum
{
    case Unknow="unknow"
    case Tencent="tencent"
    case Netcase="netcase"
}
