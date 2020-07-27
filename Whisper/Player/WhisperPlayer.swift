//
//  WhisperPlayer.swift
//  播放器
//  Whisper
//
//  Created by WeeStar on 2020/7/25.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import AVKit
import Alamofire

@objcMembers
class WhisperPlayer: NSObject,ObservableObject{
    //音乐播放器
    @Published var player:AVPlayer?=nil
    @Published var playerItem:AVPlayerItem?=nil
    
    //当前音乐相关
    @Published var curMusic:MusicModel=MusicModel()
    @Published var curList:[MusicModel]=[MusicModel]()
    
    //循环方式
    @Published var roundMode=RoundModeEnum.ListRound
    
    //状态
    @Published var isPlaying=false
    @Published var isLoading=true
    
    
    
    /// 加载
    func reload() {
        // 加载信息
        let contextData=DataService.GetContext()
//        
//        let music1=MusicModel()
//        music1.id="netrack_500427744"
//        music1.title="交易"
//        music1.artist="N7music"
//        music1.album="NiceDay7"
//        music1.source=MusicSource.Netease
//        music1.source_url="http://music.163.com/#/song?id=500427744"
//        music1.img_url="http://p2.music.126.net/RNiakf1vkBuwjC2SR2Mkkw==/109951163007592905.jpg"
//        
//        let music2=MusicModel()
//        music2.id="netrack_550004429"
//        music2.title="忘却"
//        music2.artist="苏琛"
//        music2.album="忘却"
//        music2.source=MusicSource.Tencent
//        music2.source_url="http://music.163.com/#/song?id=550004429"
//        music2.img_url="http://p2.music.126.net/I6ZpoVZr6eBwDVPCXdmGgg==/109951163256340126.jpg"
//        
//        contextData.curMusic.curList=[music1,music2]
//        contextData.curMusic.curMusic=music2
//        DataService.SaveContext(data: contextData)
        
        // 变量赋值
        if(contextData.curMusic.curMusic != nil){
            self.curList=contextData.curMusic.curList
            self.curMusic=contextData.curMusic.curMusic!
            self.roundMode=contextData.curMusic.roundMode
        }
        else{
            return
        }
        
        // 获取播放url
        // todo
        let url="http://m10.music.126.net/20200727190308/622a110a57d9671bd5d3f0ec0d2e6c0c/ymusic/6d9d/a15a/1a56/934e9b0fcfce9d0a8abe9cac7ce3f7e4.mp3"
        
        // 在线音乐数据不为空 移除观察
        if(self.playerItem != nil){
            self.playerItem!.removeObserver(self, forKeyPath: "status", context: nil)
            self.playerItem!.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
            self.playerItem!.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
            self.playerItem!.removeObserver(self,forKeyPath: "playbackLikelyToKeepUp", context: nil)
            NotificationCenter.default.removeObserver(self)
        }
        
        // 初始化在线音乐数据
        self.playerItem = AVPlayerItem(url:URL(string: url)!)
        
        // 添加监视
        self.playerItem!.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem!.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.playerItem!.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.playerItem!.addObserver(self, forKeyPath:"playbackLikelyToKeepUp", options: .new,context:nil)
        
        //创建player
        self.player = AVPlayer.init(playerItem: self.playerItem)
        self.player!.rate = 1.0//播放速度 播放前设置
        
        //        let audio=WhisperAudio(url:url)
        //        audio.postDownload(successHandler:  {(audioPath) in
        //            // 下载完毕初始化播放器
        //            self.player=try! AVAudioPlayer(contentsOf: URL(string: audio.getUrl())!)
        //            self.player.prepareToPlay()
        //
        //            // 是否立即播放
        //            if(self.isPlaying){
        //
        //            }
        //        }, errorHandler: {(AFError) in
        //            // 错误处理
        //        })
    }
    
    
    /// 更换循环方式
    func changeRoundMode(){
        var roundModeValue=self.roundMode.rawValue
        roundModeValue = roundModeValue==3 ? 1 : roundModeValue+1
        self.roundMode=RoundModeEnum.init(rawValue: roundModeValue)!
        
        // 保存配置
        let contextData=DataService.GetContext()
        contextData.curMusic.roundMode=self.roundMode
        DataService.SaveContext(data: contextData)
    }
    
    
    /// 播放
    func play(){
        self.isPlaying=true
        self.player!.play()
    }
    
    
    /// 暂停
    func pause(){
        self.isPlaying=false
        self.player!.pause()
    }
    
    
    /// 上一首
    func pre(isAuto:Bool=false){
        // 空值处理
        if(self.curList.count==0)
        {
            return
        }
        
        // 获取当前播放位置
        let curIdx=self.curList.firstIndex(where: { $0.id == curMusic.id }) ?? -1
        var nextIdx = -1
        
        // 根据循环方式获取上一首
        switch self.roundMode {
        case .ListRound:
            nextIdx = curIdx == 0||curIdx == -1 ? self.curList.count-1 : curIdx-1
        case .SingleRound:
            nextIdx = isAuto ? curIdx : (curIdx == 0||curIdx == -1 ? self.curList.count-1 : curIdx-1)
        case .RandomRound:
            var randomIdx = arc4random() % UInt32(self.curList.count)
            while self.curList.count>1 && randomIdx == curIdx {
                randomIdx = arc4random() % UInt32(self.curList.count)
            }
            nextIdx = Int(randomIdx)
        }
        
        // 更改当前音乐 写config
        if(nextIdx > -1 && nextIdx != curIdx){
            let curMus = self.curList[nextIdx]
            let contextData=DataService.GetContext()
            contextData.curMusic.curMusic=curMus
            DataService.SaveContext(data: contextData)
        }
        
        //执行reload刷新
        self.reload()
    }
    
    /// 下一首
    func next(isAuto:Bool=false){
        // 空值处理
        if(self.curList.count==0)
        {
            return
        }
        
        // 获取当前播放位置
        let curIdx=self.curList.firstIndex(where: { $0.id == curMusic.id }) ?? -1
        var nextIdx = -1
        
        // 根据循环方式获取上一首
        switch self.roundMode {
        case .ListRound:
            nextIdx = curIdx==self.curList.count-1 ? 0 : curIdx+1
        case .SingleRound:
            nextIdx = isAuto ? curIdx : (curIdx==self.curList.count ? 0 : curIdx+1)
        case .RandomRound:
            var randomIdx = arc4random() % UInt32(self.curList.count)
            while self.curList.count>1 && randomIdx == curIdx {
                randomIdx = arc4random() % UInt32(self.curList.count)
            }
            nextIdx = Int(randomIdx)
        }
        
        // 更改当前音乐 写config
        if(nextIdx > -1 && nextIdx != curIdx){
            let curMus = self.curList[nextIdx]
            let contextData=DataService.GetContext()
            contextData.curMusic.curMusic=curMus
            DataService.SaveContext(data: contextData)
        }
        
        //执行reload刷新
        self.reload()
    }
    
    
    /// 观察播放状态相关
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "status" {
            switch self.playerItem!.status{
            case .readyToPlay:
                print("ready")
                self.play()
            case .failed:
                print("failed")
                // 播放失败播放下一首
                self.next()
            case.unknown:
                print("unkonwn")
            @unknown default:
                return
            }
        }else if keyPath == "loadedTimeRanges"{
            //            let loadTimeArray = self.playerItem!.loadedTimeRanges
            //            //获取最新缓存的区间
            //            let newTimeRange : CMTimeRange = loadTimeArray.first as! CMTimeRange
            //            let startSeconds = CMTimeGetSeconds(newTimeRange.start);
            //            let durationSeconds = CMTimeGetSeconds(newTimeRange.duration);
            //            let totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            //            print("当前缓冲时间：%f",totalBuffer)
        }else if keyPath == "playbackBufferEmpty"{
            print("正在缓存视频请稍等")
            self.isLoading=true
        }
        else if keyPath == "playbackLikelyToKeepUp"{
            if(self.isLoading && self.isPlaying){
                print("缓存好了继续播放")
                self.play()
            }
            self.isLoading=false
        }
    }
}
