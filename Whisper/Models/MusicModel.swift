//
//  MusicModel.swift
//  歌曲模型
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation


/// 歌曲模型
public class MusicModel
{
    /// 歌曲ID
    var id="";
    
    /// 歌曲标题
    var title="";
    
    /// 艺术家名称
    var artist="";
    
    /// 艺术家ID
    var artist_id="";
    
    /// 专辑
    var album="";
    
    /// 专辑ID
    var album_id="";
    
    /// 来源(QQ、网易云等)
    var source=MusicSource.Unknow;
    
    /// 来源url
    var source_url="";
    
    /// url
    var url="";
    
    /// 音乐封面
    var img_url="";
    
    /// 所属歌单ID
    var sheet_id=""
    
    
    /// 歌曲播放
    func play()
    {
        //播放
        print("播放歌曲："+self.title)
    }
}

/// 音乐来源枚举
enum MusicSource:String
{
    case Unknow="unknow"
    case Tencent="tencent"
    case Netcase="netcase"
}
