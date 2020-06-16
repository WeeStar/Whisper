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
    
    /// 初始化
    /// - Parameter afterHandler: 页面完成回调
    init(afterHandler:(() -> Void)?=nil) {
        self.afterHandler=afterHandler
    }
    
    //用于聚焦动画
    @State private var focus = false
    
    var body: some View {
        ZStack{
            //背景图
            Image("welcome_1").resizable()
                .frame(
                    width:UIScreen.main.bounds.height*1.5,
                    height:UIScreen.main.bounds.height*1.5)
                .blur(radius: focus ? 5 : 0)
                .animation(.easeIn(duration: 1.5))
            
            VStack(spacing:20){
                //logo图
                Image("white").resizable()
                    .frame(width: 100,height: 100)
                    .padding(.top,100)
                
                Text("音乐无界  万象森罗")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
                
                Text("Developed by WeeStar")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.bottom,30)
            }
            .frame(height:UIScreen.main.bounds.height)
            .blur(radius: focus ? 0 : 5)
            .animation(.easeIn(duration: 1.5))
        }.onAppear(perform: {
            //开启线程
            let thread = Thread.init {
                //延时动画
                Thread.sleep(forTimeInterval: 0.25)
                self.focus.toggle()
                
                //延时打开主页
                Thread.sleep(forTimeInterval: 2.5)
                DispatchQueue.main.async {
                    self.afterHandler?()
                }
            }
            thread.start()
        })
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
