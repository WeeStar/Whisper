//
//  WhisperPlayer.swift
//  Whisper
//
//  Created by WeeStar on 2020/7/16.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI
import AVKit

struct WhisperPlayerView: View {
    @State var progress:CGFloat=0
    @ObservedObject var player:WhisperPlayer=WhisperPlayer()
    
    var body: some View {
        VStack(spacing:20){
            // 封面
            WebImageView(self.player.curMusic.img_url ?? "",isLazy: false)
                .frame(width:UIScreen.main.bounds.width*0.8,height:UIScreen.main.bounds.width*0.8)
                .cornerRadius(10)
                .padding(.top,30)
                .shadow(radius: 10)
            
            ZStack(alignment:.leading){
                Capsule().fill(Color.black.opacity(0.08)).frame(height:3)
                Capsule().fill(Color("prgBarForeColor")).frame(width:self.progress,height:3)
            }
            .padding(.top,10)
            
            // 标题
            Text(self.player.curMusic.title==nil||self.player.curMusic.title=="" ? "暂无歌曲" : self.player.curMusic.title)
                .foregroundColor(Color("textColorMain"))
                .lineLimit(1)
                .font(.title)
            // 负标题
            Text(self.player.curMusic.title==nil||self.player.curMusic.title=="" ? "" : self.player.curMusic.getDesc())
                .foregroundColor(Color("textColorSub"))
                .lineLimit(1)
            
            // 按钮
            HStack(spacing:UIScreen.main.bounds.width/5-30){
                // 循环方式
                Button(action: {
                    self.player.changeRoundMode()
                })
                {
                    Image(systemName: self.player.roundMode == RoundModeEnum.ListRound ?
                        "repeat" :
                        self.player.roundMode == RoundModeEnum.RandomRound ?
                        "shuffle" : "repeat.1").imageScale(.large)
                }
                
                // 上一首
                Button(action: {
                    self.player.pre()
//                    self.imgUrl=self.player.curMusic.img_url ?? ""
                })
                {
                    Image(systemName: "backward.end.fill").imageScale(.large)
                }
                
                // 播放暂停
                Button(action: {
                    if self.player.isPlaying{
                        self.player.pause()
                    }
                    else{
                        self.player.play()
                    }
                })
                {
                    Image(systemName:self.player.isPlaying ? "pause.fill" : "play.fill").font(.system(size: 40))
                }.frame(width:45)
                
                // 下一首
                Button(action: {
                    self.player.next()
                })
                {
                    Image(systemName: "forward.end.fill").imageScale(.large)
                }
                
                // 展示播放列表
                Button(action: {})
                {
                    Image(systemName: "list.dash").imageScale(.large)
                }
            }
            .foregroundColor(Color("textColorMain"))
            .padding(.top,20)
        }
        .background(Color("bgColorMain"))
        .padding()
        .onAppear(perform: {
            print("player appear")
            self.player.reload()
//            self.imgUrl=self.player.curMusic.img_url ?? ""
        })
    }
}

struct WhisperPlayer_Previews: PreviewProvider {
    static var previews: some View {
        WhisperPlayerView()
    }
}
