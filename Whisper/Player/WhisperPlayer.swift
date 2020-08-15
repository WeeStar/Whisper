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
import Kingfisher
import MediaPlayer

@objcMembers
class WhisperPlayer: AppDelegate,ObservableObject{
    //音乐播放器
    @Published var player:AVPlayer?=nil
    @Published var playerItem:AVPlayerItem?=nil
    
    //当前音乐相关
    @Published var curMusic:MusicModel?
    @Published var curList:[MusicModel]
    
    //循环方式
    @Published var roundMode=RoundModeEnum.ListRound
    
    //状态
    @Published var isPlaying=false//正在播放
    @Published var isSeeking=false//正在切换进度
    @Published var isLoading=false//正在加载缓存
    @Published var isChangeing:Bool = false//正在切换歌曲
        {
        //属性监听
        willSet{
            //切换歌曲时 进度置0
            if(newValue){
                self.progress=0
                self.curTime=0
                self.duration=0
            }
        }
    }
    
    
    //时间
    @Published var progress:CGFloat=0
    @Published var curTime:Double=0.0
    @Published var duration:Double=0.0
    
    //封面图片
    private var image:UIImage?=nil
    
    //单例
    static var shareIns = WhisperPlayer()
    
    /// 初始化
    private override init(){
        
        // 变量赋值
        self.curList=ContextService.contextIns.curMusic.curList
        self.curMusic=ContextService.contextIns.curMusic.curMusic
        self.roundMode=ContextService.contextIns.curMusic.roundMode
        
        super.init()
        
        //监控时间
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){(_) in
            //正在调整时间时 不监视 调整完在监视
            if(self.isSeeking)
            {
                return
            }
            self.curTime = self.playerItem == nil || self.isChangeing ? 0 : CMTimeGetSeconds(self.playerItem!.currentTime())
            self.duration = self.playerItem == nil || self.isChangeing ? 0 : CMTimeGetSeconds(self.playerItem!.asset.duration)
            self.progress = self.duration == 0 ? 0 : CGFloat(self.curTime/self.duration)
        }
    }
    
    /// 加载
    func reload(isFirstComeIn:Bool = false) {
        if(self.curMusic == nil){
            return
        }
        
        //正在切换
        self.isChangeing=true
        
        
        // 获取封面图片
        self.image = nil //置空
        if(self.curMusic!.img_url == nil){
            self.image = UIImage(named: "emptyMusic")!
        }
        else if let url = URL(string: self.curMusic!.img_url){
            //加载图片
            KingfisherManager.shared
                .retrieveImage(with: url,
                               options:  [
                                .processor(DownsamplingImageProcessor(size: CGSize(width: 600, height: 600))),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                    ],
                               progressBlock: nil,
                               completionHandler:{
                                result in
                                let image = try? result.get().image
                                if let image = image {
                                    self.image=image
                                }
                                else {
                                    self.image = UIImage(named: "emptyMusic")!
                                }
                }
            )
        }
        
        // 音乐数据不为空 移除观察
        if(self.playerItem != nil){
            self.playerItem!.removeObserver(self, forKeyPath: "status", context: nil)
            self.playerItem!.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
            self.playerItem!.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
            self.playerItem!.removeObserver(self,forKeyPath: "playbackLikelyToKeepUp", context: nil)
            
            // 播放完成通知
            NotificationCenter.default.removeObserver(self)
            self.player?.pause()
            self.playerItem = nil // 置空 防止外部观察时间
        }
        
        // 获取播放url
        HttpService.Post(module: "music", methodUrl: "music_info", musicSource: self.curMusic!.source,
                         params: ["ids":[self.curMusic!.id]],
                         successHandler: { resData in
                            //处理返回数据
                            let resArr = resData as? NSArray
                            let resDic = resArr?.firstObject as? NSDictionary
                            let url = resDic?.value(forKey: "url") as? String
                            if (url == nil||url! == ""){
                                //播放url数据异常处理
                                self.playFailHandle()
                                return
                            }
                            
                            DispatchQueue.main.async {
                                // 初始化在线音乐数据
                                self.playerItem = AVPlayerItem(url:URL(string: url!)!)
                                
                                // 添加监视
                                // 需要监听的字段和状态
                                // status :  AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay,AVPlayerItemStatusFailed
                                // loadedTimeRanges :  缓冲进度
                                // playbackBufferEmpty : seekToTime后，缓冲数据为空，而且有效时间内数据无法补充，播放失败
                                // playbackLikelyToKeepUp : seekToTime后,可以正常播放，相当于readyToPlay，一般拖动滑竿菊花转，到了这个这个状态菊花隐藏
                                self.playerItem!.addObserver(self, forKeyPath: "status", options: .new, context: nil)
                                self.playerItem!.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
                                self.playerItem!.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
                                self.playerItem!.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new,context:nil)
                                // 播放完成通知
                                NotificationCenter.default.addObserver(self, selector:  #selector(self.playFinishHandle), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem!)
                                
                                //酷狗 列表项没有图片 详情中再次获取
                                if self.curMusic!.img_url == nil {
                                    self.curMusic!.img_url = resDic?.value(forKey: "img_url") as? String
                                    
                                    if self.curMusic!.img_url != nil {
                                        if let url = URL(string: self.curMusic!.img_url){
                                            //加载图片
                                            KingfisherManager.shared
                                                .retrieveImage(with: url,
                                                               options:  [
                                                                .processor(DownsamplingImageProcessor(size: CGSize(width: 600, height: 600))),
                                                                .transition(.fade(1)),
                                                                .cacheOriginalImage
                                                    ],
                                                               progressBlock: nil,
                                                               completionHandler:{
                                                                result in
                                                                let image = try? result.get().image
                                                                if let image = image {
                                                                    self.image=image
                                                                }
                                                                else {
                                                                    self.image = UIImage(named: "emptyMusic")!
                                                                }
                                                }
                                            )
                                        }
                                    }
                                }
                                
                                //创建player
                                self.isPlaying = !isFirstComeIn // 此处播放状态置位true,方便加载完成状态播放,不通过判断ready状态播放,因后台进入会引发ready
                                self.player = AVPlayer.init(playerItem: self.playerItem)
                                
                                //切换完毕
                                self.isChangeing=false
                            }
        },
                         failHandler: {errorMsg in
                            //接口请求错误 播放url数据异常处理
                            self.playFailHandle()
        })
    }
    
    
    /// 更换循环方式
    func changeRoundMode(){
        var roundModeValue=self.roundMode.rawValue
        roundModeValue = roundModeValue==3 ? 1 : roundModeValue+1
        self.roundMode=RoundModeEnum.init(rawValue: roundModeValue)!
        
        // 保存配置
        ContextService.contextIns.curMusic.roundMode=self.roundMode
        ContextService.SaveContext()
    }
    
    
    /// 播放
    func play(){
        if(self.playerItem == nil){
            return
        }
        self.isPlaying=true
        self.player!.play()
        self.setInfoCenterCredentials()
    }
    
    
    /// 暂停
    func pause(){
        if(self.playerItem == nil){
            return
        }
        self.isPlaying=false
        self.player!.pause()
        self.setInfoCenterCredentials()
    }
    
    
    /// 上一首
    func pre(isAuto:Bool=false){
        // 空值处理
        if(self.curList.count==0 || self.curMusic == nil)
        {
            return
        }
        
        // 获取当前播放位置
        let curIdx=self.curList.firstIndex(where: { $0.id == self.curMusic!.id }) ?? -1
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
            self.isChangeing=true
            self.curMusic = self.curList[nextIdx]
            ContextService.contextIns.curMusic.curMusic=self.curMusic
            ContextService.SaveContext()
        }
        
        //执行reload刷新
        self.reload()
    }
    
    /// 下一首
    func next(isAuto:Bool=false){
        // 空值处理
        if(self.curList.count==0 || self.curMusic == nil)
        {
            return
        }
        
        // 获取当前播放位置
        let curIdx=self.curList.firstIndex(where: { $0.id == self.curMusic!.id }) ?? -1
        var nextIdx = -1
        
        // 根据循环方式获取下一首
        switch self.roundMode {
        case .ListRound:
            nextIdx = curIdx==self.curList.count-1 ? 0 : curIdx+1
        case .SingleRound:
            nextIdx = isAuto ? curIdx : (curIdx==self.curList.count-1 ? 0 : curIdx+1)
        case .RandomRound:
            var randomIdx = arc4random() % UInt32(self.curList.count)
            while self.curList.count>1 && randomIdx == curIdx {
                randomIdx = arc4random() % UInt32(self.curList.count)
            }
            nextIdx = Int(randomIdx)
        }
        
        // 更改当前音乐 写config
        if(nextIdx > -1 && nextIdx != curIdx || self.playerItem == nil){
            self.isChangeing=true
            self.curMusic = self.curList[nextIdx]
            ContextService.contextIns.curMusic.curMusic=self.curMusic
            ContextService.SaveContext()
            //执行reload刷新
            self.reload()
        }
        else{
            // 当前音乐未修改 直接跳到0 重新播放
            self.playerItem!.seek(to: .zero, completionHandler: {(_) in
                self.play()
            })
        }
    }
    
    
    /// 进度跳转
    func seek(seekTime:CMTime,completionHandler:((Bool)->Void)?){
        if(self.playerItem == nil){
            return
        }
        
        if(seekTime > self.playerItem!.duration){
            return
        }
        
        self.isSeeking=true
        // 置时间
        self.curTime = CMTimeGetSeconds(seekTime)
        self.duration = CMTimeGetSeconds(self.playerItem!.asset.duration)
        self.progress = self.duration == 0 ? 0 : CGFloat(self.curTime/self.duration)
        
        self.playerItem!.seek(to: seekTime, completionHandler: {(state) in
            self.play()
            completionHandler?(state)//执行回调
            self.isSeeking=false
        })
    }
    
    
    /// 播放歌单
    func newSheet(playSheet:SheetModel,playMusicIndex:Int = 0){
        // 空值处理
        if(playSheet.tracks.count==0)
        {
            return
        }
        
        //替换当前列表
        self.curList = playSheet.tracks
        self.isChangeing=true
        self.curMusic = self.curList[playMusicIndex]
        
        //写配置 todo：写最近播放歌单
        ContextService.contextIns.curMusic.curList = self.curList
        ContextService.contextIns.curMusic.curMusic=self.curMusic
        ContextService.SaveContext()
        
        //执行reload刷新
        self.reload()
    }
    
    /// 播放单曲
    func newMusic(playMusic:MusicModel){
        // 空值处理
        if(playMusic.id == "" || !playMusic.isPlayable())
        {
            return
        }
        
        // 获取当前播放位置
        let curIdx=self.curList.firstIndex(where: { $0.id == self.curMusic!.id }) ?? -1
        var newIdx=self.curList.firstIndex(where: { $0.id == playMusic.id }) ?? -1
        
        // 新歌曲不在其中 放到当前之后
        if(newIdx == -1){
            newIdx = curIdx + 1
            self.curList.insert(playMusic, at: newIdx)
        }
        
        // 更改当前音乐 写config
        if(newIdx > -1 && newIdx != curIdx || self.playerItem == nil){
            self.isChangeing=true
            self.curMusic = self.curList[newIdx]
            ContextService.contextIns.curMusic.curList = self.curList
            ContextService.contextIns.curMusic.curMusic=self.curMusic
            ContextService.SaveContext()
            //执行reload刷新
            self.reload()
        }
        else{
            // 当前音乐未修改 直接跳到0 重新播放
            self.playerItem!.seek(to: .zero, completionHandler: {(_) in
                self.play()
            })
        }
    }
    
    
    /// 当前歌曲播放完成处理
    @objc func playFinishHandle(note: NSNotification) {
        // 播放下一首
        print("finish")
        self.next(isAuto: true)
    }
    
    
    /// 当前歌曲播放失败处理
    private func playFailHandle(){
        // 写入不能播放标记
        // 跳下一首
        self.next()
    }
    
    /// 观察播放状态相关
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "status" {
            print(self.playerItem!.status)
            switch self.playerItem!.status{
            case .readyToPlay:
                print("ready")
                //                self.play()
                break
            case .failed:
                print("failed")
                // 播放失败播放下一首
                self.next()
                break
            case.unknown:
                print("unkonwn")
                break
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
            if(self.isPlaying){
                print("缓存好了继续播放")
                self.play()
            }
            self.isLoading=false
        }
    }
    
    
    
    // 设置后台播放显示信息
    private func setInfoCenterCredentials() {
        let mpic = MPNowPlayingInfoCenter.default()
        
        //专辑封面
        let mySize = CGSize(width: 400, height: 400)
        let albumArt = MPMediaItemArtwork(boundsSize:mySize) { sz in
            return self.image ?? UIImage(named: "emptyMusic")!
        }
        
        //获取进度
        let postion = self.playerItem != nil ? CMTimeGetSeconds(self.playerItem!.currentTime()) : 0.0
        let duration = self.playerItem != nil ? CMTimeGetSeconds(self.playerItem!.duration) : 0.0
        
        
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle: self.curMusic?.title ?? "暂无歌曲",
                               MPMediaItemPropertyArtist: self.curMusic?.getDesc() ?? "未知",
                               MPMediaItemPropertyArtwork: albumArt,
                               MPNowPlayingInfoPropertyElapsedPlaybackTime: postion,
                               MPMediaItemPropertyPlaybackDuration: duration,
                               MPNowPlayingInfoPropertyPlaybackRate: (self.playerItem?.isPlaybackLikelyToKeepUp ?? false) ?
                                (self.player?.rate ?? 0) : 0]
    }
}
