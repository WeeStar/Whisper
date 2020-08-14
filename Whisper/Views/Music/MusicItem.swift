//
//  MusicItem.swift
//  歌曲单项
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 歌单单项
struct MusicItem: View {
    
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
        HStack(spacing:5){
            VStack(alignment: .trailing){
                Text(String(self.musicIdx))
                    .foregroundColor(Color("textColorSub"))
                    .lineLimit(1)
                    .frame(width:33)
                    .font(String(self.musicIdx).count>2 ? .footnote : .body)
            }
            VStack(alignment: .leading,spacing: 4){
                HStack{
                    //歌曲标题
                    Text(self.musicInfo.title)
                        .foregroundColor(Color(self.musicInfo.isPlayable() ? "textColorMain" : "textColorSub"))
                        .lineLimit(1)
                        .font(.body)
                    
                    if(!self.musicInfo.isPlayable()){
                        Text("失效")
                        .foregroundColor(Color("textColorSub"))
                            .font(.system(size: 10))
                        .frame(width:30,height:16)
                        .overlay(
                            //边框
                            RoundedRectangle(cornerRadius: 3, style: .circular)
                                .stroke(Color("textColorSub"), lineWidth: 1)
                        )
                    }
                }
                .padding(.trailing)
                
                HStack{
                    //来源种类
                    Image(self.musicInfo.source!.rawValue).resizable().frame(width: 15, height: 15)
                    //歌曲描述
                    Text(self.musicInfo.getDesc())
                        .foregroundColor(Color("textColorSub"))
                        .lineLimit(1)
                        .font(.footnote)
                        .padding(.trailing)
                }
            }
            Spacer()
        }
        .padding(.leading,5)
        .frame(height:50)
        .background(Color(.white).opacity(0.001))
    }
}

struct SheetItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let music=MusicModel()
        music.id="netrack_500427744"
        music.title="交易"
        music.artist="N7music"
        music.album="NiceDay7"
        music.source=MusicSource.Netease
        music.source_url="http://music.163.com/#/song?id=500427744"
        music.img_url="http://p2.music.126.net/RNiakf1vkBuwjC2SR2Mkkw==/109951163007592905.jpg"
        
        return Group {
            MusicItem(music:music,musicIdx: 1)
            MusicItem(music:music,musicIdx: 2033)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
