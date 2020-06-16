//
//  SheetItem.swift
//  歌单单项
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 歌单单项
struct SheetItem: View {
    
    /// 初始化
    /// - Parameter music: 音乐信息
    init(music:MusicModel) {
        self.musicInfo=music
    }
    
    /// 音乐信息
    private var musicInfo:MusicModel
    
    
    var body: some View {
        VStack(alignment: .leading,spacing: 5){
            //歌曲标题
            Text(musicInfo.title).font(.body)
            
            HStack{
                //来源种类
                Image(musicInfo.source!.rawValue).resizable().frame(width: 20, height: 20)
                //歌曲描述
                Text(musicInfo.getDesc()).font(.footnote).foregroundColor(.gray)
            }
        }
        .padding(.leading,5)
        .frame(height:50)
    }
}

struct SheetItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let music=MusicModel()
        music.id="netrack_500427744"
        music.title="交易"
        music.artist="N7music"
        music.album="NiceDay7"
        music.source=MusicSource.Netcase
        music.source_url="http://music.163.com/#/song?id=500427744"
        music.img_url="http://p2.music.126.net/RNiakf1vkBuwjC2SR2Mkkw==/109951163007592905.jpg"
        
        return Group {
            SheetItem(music:music)
            SheetItem(music:music)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
