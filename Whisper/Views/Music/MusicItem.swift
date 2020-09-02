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
    init(music:MusicModel,musicIdx:Int,delHandler:((MusicModel)->Void)? = nil,isPlaying:Bool = false) {
        self.musicInfo=music
        self.musicIdx=musicIdx
        self.delHandler = delHandler
        self.isPlaying = isPlaying
    }
    
    /// 音乐信息
    private var musicIdx:Int
    private var musicInfo:MusicModel
    private var delHandler:((MusicModel)->Void)?
    private var isPlaying:Bool
    
    
    var body: some View {
        HStack(spacing:5){
            //序号
            Text(String(self.musicIdx))
            .foregroundColor(Color("textColorSub"))
            .lineLimit(1)
            .frame(width:33)
            .font(String(self.musicIdx).count>2 ? .footnote : .body)
            
            VStack(alignment: .leading,spacing: 4){
                //主标题
                HStack{
                    //歌曲标题
                    Text(self.musicInfo.title)
                        .foregroundColor(Color(self.isPlaying ? "ThemeColorMain" : (self.musicInfo.isPlayable() ? "textColorMain" : "textColorSub")))
                        .lineLimit(1)
                        .font(.body)
                    
                    //歌曲失效
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
                
                //副标题
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
            
            if(self.delHandler != nil){
                Button(action:{
                    self.delHandler!(self.musicInfo)
                }){
                    Image(systemName: "xmark")
                        .foregroundColor(Color("textColorSub"))
                        .frame(width:20,height: 20)
                        .background(Color(.white).opacity(0.001))
                    .padding(5)
                }
                .padding(.trailing,5)
                .buttonStyle(PlainButtonStyle())
            }
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
        music.title="交NiceDay7NiceDay7NiceDay7易"
        music.artist="N7music"
        music.album="NiceDay7NiceDay7NiceDay7NiceDay7NiceDay7NiceDay7"
        music.source=MusicSource.Netease
        music.source_url="http://music.163.com/#/song?id=500427744"
        music.img_url="http://p2.music.126.net/RNiakf1vkBuwjC2SR2Mkkw==/109951163007592905.jpg"
        
        return Group {
            MusicItem(music:music,musicIdx: 1,delHandler: {music in return })
            MusicItem(music:music,musicIdx: 2033)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
