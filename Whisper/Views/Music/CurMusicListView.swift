//
//  CurMusicListView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/27.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct CurMusicListView: View {
    @ObservedObject var player:WhisperPlayer = WhisperPlayer.shareIns
    
    //弹列表相关
    @Binding var isShowList:Bool
//    @State private var offset:CGFloat? = nil
    
    private let showOffset = UIScreen.main.bounds.height * 0.05
    private let hideOffset = UIScreen.main.bounds.height * 1.1
    
    var body: some View {
        VStack{
            // 头部拖动区域
            HStack{
                Spacer()
                
                Capsule()
                    .foregroundColor(Color(.lightGray)).opacity(0.7)
                    .frame(width: UIScreen.main.bounds.width*0.2, height: 5)
                    .padding(10)
                
                Spacer()
            }
            .frame(height:30)
            .onTapGesture {
                self.isShowList = false
            }
            
            //滚动列表
            List{
                VStack(alignment: .leading){
                    //列表信息
                    ForEach(0..<self.player.curList.count,id:\.self) {i in
                        MusicItem(music: self.player.curList[i],musicIdx: i+1,delHandler:
                            { _ in
                                self.player.delMusic(delIdx: i)
                        },isPlaying: self.player.curMusic == self.player.curList[i])
                            .onTapGesture {
                                self.player.jumpMusic(jumpIdx: i)
                                Thread.init {
                                    Thread.sleep(forTimeInterval: 0.5)
                                    DispatchQueue.main.async {
                                        self.isShowList = false
                                    }
                                }.start()
                        }
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth:.infinity, minHeight: 500, alignment: .leading)
            }
        }
        .background(Color("bgColorMain"))
        .edgesIgnoringSafeArea(.all)
        .frame(height:UIScreen.main.bounds.height * 0.95)
        .cornerRadius(20)
        .shadow(radius: 5)
//        .offset(y:self.offset == nil ? (self.isShowList ? self.showOffset : self.hideOffset) : self.offset!)
        .offset(y:self.isShowList ? self.showOffset : self.hideOffset)
        .animation(.linear(duration: 0.2))
        .gesture(
            DragGesture()
//                .onChanged({value in
//                    print(value.translation.height)
//                    if(value.translation.height < 0){
//                        return
//                    }
//                    withAnimation(.linear(duration: 0.2)){
//                        self.offset = value.translation.height + self.showOffset
//                    }
//                })
                .onEnded({value in
                    if value.predictedEndTranslation.height < UIScreen.main.bounds.height * 0.4{
                        self.isShowList = true
//                        self.offset = nil
                    }
                    else {
                        self.isShowList = false
//                        self.offset = nil
                    }
                }
            )
        )
    }
}
