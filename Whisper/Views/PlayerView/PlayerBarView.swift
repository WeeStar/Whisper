//
//  PlayerBarView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/5.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerBarView: View {
    @Binding var showPlayerView:Bool
    @ObservedObject var player:WhisperPlayer
    
    var body: some View {
        VStack(spacing:0){
            Rectangle()
                .foregroundColor(Color(.lightGray))
                .frame(height:0.5)
            
            HStack(alignment: .center,spacing:0){
                HStack(alignment: .center, spacing: 0)
                {
                    WebImageView(self.player.curMusic?.img_url ?? "",qulity: ImageQulity.Mideum)
                        .frame(width:50,height:50)
                        .cornerRadius(5)
                        .shadow(radius: 3)
                        .padding(.vertical,8)
                        .padding(.horizontal,20)
                    
                    VStack(alignment: .leading){
                        // 标题
                        Text((self.player.curMusic?.title ?? "暂无歌曲"))
                            .foregroundColor(Color("textColorMain"))
                            .lineLimit(1)
                            .font(.callout)
                        
                        // 负标题
                        Text(self.player.curMusic?.getDesc() ?? "未知" )
                            .foregroundColor(Color("textColorSub"))
                            .lineLimit(1)
                            .font(.footnote)
                            .padding(.top,2)
                    }
                    
                    Spacer()
                }
                .onTapGesture {
                    
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
                    Image(systemName:self.player.isPlaying ? "pause.fill" : "play.fill").imageScale(.large)
                        .foregroundColor(Color("textColorMain"))
                        .frame(width:40,height:55)
                }
                .padding(.trailing,5)
                
                // 下一首
                Button(action: {
                    self.player.next()
                })
                {
                    Image(systemName: "forward.end.fill").imageScale(.large)
                        .foregroundColor(Color("textColorMain"))
                        .frame(width:40,height:55)
                }
                .padding(.trailing,10)
            }
        }
        .background(BlurView(.systemThinMaterial))
    }
}
