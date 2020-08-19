//
//  SearchMusicResItem.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SearchMusicResItem: View {
    /// 初始化
    /// - Parameter music: 音乐信息
    init(music:MusicModel) {
        self.musicInfo=music
    }
    
    /// 音乐信息
    private var musicInfo:MusicModel
    
    
    var body: some View {
        HStack(spacing:5){
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


