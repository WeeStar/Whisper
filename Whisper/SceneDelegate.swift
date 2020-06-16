//
//  SceneDelegate.swift
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        
        let music1=MusicModel()
        music1.id="netrack_500427744"
        music1.title="交易"
        music1.artist="N7music"
        music1.album="NiceDay7"
        music1.source=MusicSource.Netcase
        music1.source_url="http://music.163.com/#/song?id=500427744"
        music1.img_url="http://p2.music.126.net/RNiakf1vkBuwjC2SR2Mkkw==/109951163007592905.jpg"
        
        let music2=MusicModel()
        music2.id="netrack_550004429"
        music2.title="忘却"
        music2.artist="苏琛"
        music2.album="忘却"
        music2.source=MusicSource.Tencent
        music2.source_url="http://music.163.com/#/song?id=550004429"
        music2.img_url="http://p2.music.126.net/I6ZpoVZr6eBwDVPCXdmGgg==/109951163256340126.jpg"
        
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="https://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        sheet.tracks.append(music1)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        sheet.tracks.append(music2)
        
        
        
        var rootView = WelcomeView()
        
        //欢迎页面执行完毕 显示主页
        rootView.afterHandler={
              self.window?.rootViewController = UIHostingController(rootView: SheetView(sheet: sheet))
        }

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

