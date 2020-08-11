//
//  SheetBannerView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/1.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SheetBannerView: View {
    // banner 数据
    let bannerDatas:[SheetModel]
    let tapCallBack:((Int) -> Void)?
    
    @State private var isDraging = false
    @State private var index:Int = 0
    @State private var offset:CGFloat = 0
    @State private var hasTimer=false
    
    init(bannerDatas:[SheetModel],tapCallBack:((Int) -> Void)?) {
        if(bannerDatas.count>0){
            self.bannerDatas = bannerDatas
            self.tapCallBack = tapCallBack
        }
        else{
            let emptySheet = SheetModel()
            self.bannerDatas = [emptySheet]
            self.tapCallBack = nil
        }
    }
    
    var body: some View {
        GeometryReader{ gemo in
            HStack(spacing:0){
                ForEach(self.bannerDatas){ pageData in
                    SheetBigView(sheet: pageData)
                        .padding(.leading, UIScreen.main.bounds.width*0.1)
                        .padding(.trailing, UIScreen.main.bounds.width*0.1)
                        .gesture(TapGesture().onEnded{
                            self.tapCallBack?(self.index)
                        })
                }
            }
            .offset(x:self.offset)
            .frame(width:gemo.size.width,alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({value in
                        // 拖动中停止切换
                        self.isDraging = true
//                        self.changeThread?.cancel()
                        
                        withAnimation{
                            self.offset = value.translation.width - (CGFloat(self.index) * gemo.size.width)
                        }
                    })
                    .onEnded({value in
                        if value.predictedEndTranslation.width < gemo.size.width/2 , self.index < self.bannerDatas.count-1{
                            self.index += 1
                        }
                        else if value.predictedEndTranslation.width > gemo.size.width/2 , self.index > 0{
                            self.index -= 1
                        }
                        withAnimation{
                            self.offset = -(CGFloat(self.index) * gemo.size.width)
                        }
                        
                        //拖动完毕重启切换
                        self.isDraging = false
//                        self.changeThread?.start()
                    })
            )
        }
        .frame(height:UIScreen.main.bounds.width*0.8)
        .onAppear(perform: {
            //防止重复设置定时器
            if(self.hasTimer){
                return
            }
            self.hasTimer = true
            
            Timer.scheduledTimer(withTimeInterval: 8, repeats: true){(_) in
                if(self.isDraging)
                {
                    return
                }
                
                if(self.index < self.bannerDatas.count-1){
                    self.index += 1
                }
                else{
                    self.index = 0
                }
                withAnimation{
                    self.offset = -(CGFloat(self.index) * UIScreen.main.bounds.width)
                }
            }
        })
    }
}
