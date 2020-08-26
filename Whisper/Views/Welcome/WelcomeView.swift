//
//  WelcomeMain.swift
//  开屏页面
//  Whisper
//
//  Created by WeeStar on 2020/6/16.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 开屏页面
struct WelcomeView: View {
    //页面完成执行方法
    private var afterHandler : (() -> Void)?
    @State private var isReqestOver=false
    @State private var showAlert = false
    //用于聚焦动画
    @State private var focus = false
    
    /// 初始化
    /// - Parameter afterHandler: 页面完成回调
    init(afterHandler:(() -> Void)?=nil) {
        self.afterHandler=afterHandler
    }
    
    var body: some View {
        ZStack(alignment: .center){
            //背景图
            Image("welcome_1")
                .resizable()
                .aspectRatio(contentMode: ContentMode.fill)
                .frame(height:UIScreen.main.bounds.height*1.1)
                .blur(radius: focus ? 5 : 0)
                .animation(.easeIn(duration: 1.2))
            
            HStack(alignment: .center){
                Spacer()
                VStack(alignment: .center,spacing:20){
                    Spacer()
                    Spacer()
                    //logo图
                    Image("white")
                        .resizable()
                        .frame(width: 100,height: 100)
                    
                    Text("音乐无界  万象森罗")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("Developed by WeeStar")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                    
                    Spacer()
                }
                .blur(radius: self.focus ? 0 : 5)
                .animation(.easeIn(duration: 1.2))
                Spacer()
            }
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("无法连接网络"),
                  message: Text("无法连接网络，请在设置中允许Whisper网络访问"),
                  dismissButton: .default(Text("重试")){
                    self.getRecom()
                })
        }
        .onAppear(perform: {
            self.getRecom()
            
            //延时动画
            let thread = Thread.init {
                Thread.sleep(forTimeInterval: 0.2)
                DispatchQueue.main.async {
                    self.focus.toggle()
                }
            }
            thread.start()
        })
    }
    
    private func getRecom(){
        // 获取推荐歌单
        RecomService.GetRecom(allCompleteHandler: {
            self.isReqestOver=true
        })
        
        //开启线程
        let thread = Thread.init {
            //延时开始扫描结果
            Thread.sleep(forTimeInterval: 1.7)
            
            //等待请求完毕
            var times = 0
            while !self.isReqestOver {
                Thread.sleep(forTimeInterval: 0.5)
                times += 1
                if(times == 10){
                    self.showAlert = true
                    break
                }
            }
            
            //打开主页
            if(times < 10){
                DispatchQueue.main.async {
                    self.afterHandler?()
                }
            }
        }
        thread.start()
    }
}

struct WelcomeMain_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            WelcomeView()
                .previewDevice(PreviewDevice(rawValue: deviceName)).previewDisplayName(deviceName)
        }
        
    }
}
