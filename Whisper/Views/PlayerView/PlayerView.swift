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
    //下拉相关
    @Binding var showPlayerView:Bool
    @State var playerOpacity:Double=0
    @State var offset:CGFloat=0
    
    @ObservedObject var player:WhisperPlayer
    
    // 进度相关
    var progressBarWidth=UIScreen.main.bounds.width*0.8
    // 拖动进度相关
    @State var isSeeking = false
    @State var seekProgress:CGFloat=0
    @State var seekCurTime=CMTimeMake(value: 0, timescale: 1)
    
    
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            VStack(spacing:20){
                
                Group{
                    Spacer(minLength: 0)
                    // 封面
                    WebImageView(self.player.curMusic?.img_url ?? "")
                        .frame(width:self.progressBarWidth,height:self.progressBarWidth)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.top,UIScreen.main.bounds.height*0.03)
                }
                .gesture(
                    DragGesture()
                        .onChanged({value in
                            withAnimation{
                                self.offset = value.translation.height
                            }
                        })
                        .onEnded({value in
                            var of:CGFloat = 0
                            if value.predictedEndTranslation.height < UIScreen.main.bounds.height * 0.3{
                                of=0
                            }
                            else{
                                of = UIScreen.main.bounds.height
                            }
                            withAnimation{
                                self.offset = of
                            }
                        })
                )
                
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
                            .gesture(DragGesture()
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
                        Text(self.formatPlayTime(secounds : self.isSeeking ? CMTimeGetSeconds(self.seekCurTime) : self.player.curTime))
                            .foregroundColor(Color("textColorSub"))
                            .font(.footnote)
                        
                        Spacer()
                        
                        Text(self.formatPlayTime(secounds : self.player.duration))
                            .foregroundColor(Color("textColorSub"))
                            .font(.footnote)
                    }
                    .frame(width:UIScreen.main.bounds.width*0.8)
                    .padding(.top,1)
                }
                .padding(.top,3)
                
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
                    
                    Spacer(minLength: 0)
                }
                .padding(.top,15)
                
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
                    }.frame(width:20)
                    
                    // 上一首
                    Button(action: {
                        self.player.pre()
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
                    }.frame(width:42)
                    
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
                //                .padding(.top,UIScreen.main.bounds.height*0.15)
                
                Spacer(minLength: 0)
            }
            Spacer()
        }
        .background(Color("bgColorMain"))
        .edgesIgnoringSafeArea(.all)
        .opacity(1-self.playerOpacity)
    }
    
    private func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "0:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(Int(secounds) % 60)
        return String(format: "%d:%02d", Min, Sec)
    }
}
