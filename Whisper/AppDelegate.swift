//
//  AppDelegate.swift
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 注册后台播放
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error)
        }
        
        //监听远程控制
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            self.becomeFirstResponder()
        }
        
        //设置Navigationbar按钮颜色
        UINavigationBar.appearance().tintColor = UIColor(named: "ThemeColorMain")
        
        //设置NavigationTitle颜色
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "textColorMain")!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "textColorMain")!]
        
        //设置List 背景色
        UITableView.appearance().backgroundColor = UIColor(named: "bgColorMain")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "bgColorMain")
        UITableView.appearance().tableFooterView = UIView()
        
        //设置ScrollView 背景色
        UIScrollView.appearance().backgroundColor = UIColor(named: "bgColorMain")
        
        return true
    }
    
    var isForceLandscape:Bool = false
    var isForcePortrait:Bool = false
    var isForceAllDerictions:Bool = false //支持所有方向
    
    /// 设置屏幕支持的方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isForceAllDerictions == true {
            return .all
        } else if isForceLandscape == true {
            return .landscape
        } else if isForcePortrait == true {
            return .portrait
        }
        return .portrait
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    /// 锁屏控制
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            print("no event\n")
            return
        }
        
        if event.type == UIEvent.EventType.remoteControl {
            switch event.subtype {
            case .remoteControlPlay:
                //播放
                WhisperPlayer.shareIns.play()
                break
            case .remoteControlPause:
                //暂停
                WhisperPlayer.shareIns.pause()
                break
            case .remoteControlStop:
                //停止
                WhisperPlayer.shareIns.pause()
                break
            case .remoteControlTogglePlayPause:
                //切换播放暂停（耳机线控）
                if(WhisperPlayer.shareIns.isPlaying){
                    WhisperPlayer.shareIns.pause()
                }
                else{
                    WhisperPlayer.shareIns.play()
                }
                break
                
            case .remoteControlNextTrack:
                //下一首
                WhisperPlayer.shareIns.next()
                break
            case .remoteControlPreviousTrack:
                //上一首
                WhisperPlayer.shareIns.pre()
                break
            case .remoteControlBeginSeekingBackward:
                //开始快退
                print("开始快退")
                break
            case .remoteControlEndSeekingBackward:
                //结束快退
                print("结束快退")
                break
            case .remoteControlBeginSeekingForward:
                //开始快进
                print("开始快退")
                break
            case .remoteControlEndSeekingForward:
                //结束快进
                print("结束快进")
                break
            default:
                break
            }
        }
    }
    
    //是否能成为第一响应对象
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

