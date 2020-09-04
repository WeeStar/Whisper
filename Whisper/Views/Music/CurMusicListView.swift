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
    
    @Binding var isShowList:Bool
    
    var body: some View {
        //滚动列表
        ScrollView(.vertical){
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
        .background(Color("bgColorMain"))
    }
}
