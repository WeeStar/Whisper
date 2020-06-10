//
//  Sheet.swift
//  歌单模型
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation

/// 歌曲模型
public class SheetModel
{
    /// 歌单ID
    var id="";
    
    /// 歌单标题
    var title=""
    
    /// 歌单封面
    var cover_img_url=""
    
    /// 歌单来源
    var source_url=""
    
    /// 歌曲列表
    var tracks=[MusicModel]()
}
