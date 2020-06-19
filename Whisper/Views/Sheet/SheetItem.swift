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
    init(music:MusicModel,musicIdx:Int) {
        self.musicInfo=music
        self.musicIdx=musicIdx
    }
    
    /// 音乐信息
    private var musicIdx:Int
    private var musicInfo:MusicModel
    
    
    var body: some View {
        HStack{
            VStack(alignment: .trailing){
                Text(String(self.musicIdx))
                    .foregroundColor(Color("textColorSub"))
                    .lineLimit(1)
                    .frame(width:33)
                    .font(String(self.musicIdx).count>2 ? .footnote : .body)
            }
            VStack(alignment: .leading,spacing: 4){
                //歌曲标题
                Text(self.musicInfo.title)
                    .foregroundColor(Color("textColorMain"))
                    .lineLimit(1)
                    .font(.body)
                
                HStack{
                    //来源种类
                    Image(self.musicInfo.source!.rawValue).resizable().frame(width: 15, height: 15)
                    //歌曲描述
                    Text(self.musicInfo.getDesc())
                    .foregroundColor(Color("textColorSub"))
                        .lineLimit(1)
                        .font(.footnote)
                }
            }
        }
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
            SheetItem(music:music,musicIdx: 1)
            SheetItem(music:music,musicIdx: 2033)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
