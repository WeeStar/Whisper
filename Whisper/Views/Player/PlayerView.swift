//
//  WhisperPlayer.swift
//  Whisper
//
//  Created by WeeStar on 2020/7/16.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @ObservedObject var player:WhisperPlayer = WhisperPlayer.shareIns
    
    // 进度相关
    var progressBarWidth=UIScreen.main.bounds.width*0.8
    // 拖动进度相关
    @State private var isSeeking = false
    @State private var seekProgress:CGFloat=0
    @State private var seekCurTime=CMTimeMake(value: 0, timescale: 1)
    
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            VStack(spacing:0){
                Group{
                    Capsule()
                        .foregroundColor(Color(.lightGray)).opacity(0.7)
                        .frame(width: UIScreen.main.bounds.width*0.2, height: 5)
                        .padding(.top,10)
                    // 封面
                    WebImageView(self.player.curMusic?.img_url ?? "")
                        .frame(width:self.progressBarWidth,height:self.progressBarWidth)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top,20)
                }
                
                // 进度条
                VStack{
                    // 进度条
                    ZStack(alignment:.leading){
                        // 总进度
                        Capsule().fill(Color.black.opacity(0.08)).frame(width:self.progressBarWidth,height:3)
                        
                        // 当前进度 播放器切换 无进度
                        Capsule().fill(Color("prgBarForeColor")).frame(width:
                            self.progressBarWidth * (self.isSeeking ? self.seekProgress : self.player.progress),height:3)
                            // 拖动事件
                            .highPriorityGesture(DragGesture()
                                .onChanged({(value) in
                                    if(self.player.playerItem == nil || self.player.isChangeing){
                                        return
                                    }
                                    
                                    let x = value.location.x
                                    
                                    // 拖动 根据位置修改拖动比例及拖动时间
                                    self.seekProgress = x/self.progressBarWidth
                                    self.seekCurTime=CMTimeMake(value: Int64(CMTimeGetSeconds(self.player.playerItem!.duration) * Double(self.seekProgress)), timescale: 1)
                                    
                                    // 置拖动状态
                                    self.isSeeking = true
                                })
                                .onEnded({(value) in
                                    if(self.player.playerItem == nil || self.player.isChangeing){
                                        return
                                    }
                                    
                                    let x = value.location.x
                                    
                                    // 拖动完成 根据位置修改拖动比例及拖动时间
                                    self.seekProgress = x/self.progressBarWidth
                                    self.seekCurTime=CMTimeMake(value: Int64(CMTimeGetSeconds(self.player.playerItem!.duration) * Double(self.seekProgress)), timescale: 1)
                                    
                                    print(self.seekProgress)
                                    
                                    // 拖动完毕 跳转进度
                                    self.player.seek(seekTime: self.seekCurTime, completionHandler: {(_) in
                                        // 置回拖动状态
                                        self.isSeeking = false
                                    })
                                }))
                    }
                    
                    // 时间文字
                    HStack{
                        Text(Utility.playTimeFormat(secounds : self.isSeeking ? CMTimeGetSeconds(self.seekCurTime) : self.player.curTime))
                            .foregroundColor(Color("textColorSub"))
                            .font(.footnote)
                            .frame(width:30).background(Color("bgColorMain"))
                        
                        Spacer()
                        
                        Text(Utility.playTimeFormat(secounds : self.player.duration))
                            .foregroundColor(Color("textColorSub"))
                            .font(.footnote)
                    }
                    .frame(width:UIScreen.main.bounds.width*0.8)
                    .padding(.top,1)
                }
                .padding(.top,15)
                
                //主副标题
                VStack{
                    // 标题
                    Text((self.player.curMusic?.title ?? "暂无歌曲"))
                        .foregroundColor(Color("textColorMain"))
                        .lineLimit(1)
                        .font(.title)
                    
                    // 负标题
                    Text(self.player.curMusic?.getDesc() ?? "未知" )
                        .foregroundColor(Color("textColorSub"))
                        .lineLimit(1)
                        .padding(.top,3)
                }
                .padding(.top,12)
                
                Spacer(minLength: 0)
                
                // 按钮
                HStack(spacing:UIScreen.main.bounds.width/5-35){
                    // 循环方式
                    Button(action: {
                        self.player.changeRoundMode()
                    })
                    {
                        Image(systemName: self.player.roundMode == RoundModeEnum.ListRound ?
                            "repeat" :
                            self.player.roundMode == RoundModeEnum.RandomRound ?
                                "shuffle" : "repeat.1").imageScale(.large)
                            .frame(width: 25, height: 25)
                    }
                    
                    // 上一首
                    Button(action: {
                        self.player.pre()
                    })
                    {
                        Image(systemName: "backward.end.fill").imageScale(.large)
                            .frame(width: 25, height: 25)
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
                            .frame(width: 45, height: 45)
                    }
                    
                    // 下一首
                    Button(action: {
                        self.player.next()
                    })
                    {
                        Image(systemName: "forward.end.fill").imageScale(.large)
                            .frame(width: 25, height: 25)
                    }
                    
                    // 展示播放列表
                    Button(action: {})
                    {
                        Image(systemName: "list.dash").imageScale(.large)
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.top,15)
                .padding(.bottom,65)
                .foregroundColor(Color("textColorMain"))
            }
            Spacer()
        }
        .background(Color("bgColorMain"))
        .edgesIgnoringSafeArea(.all)
    }
}
