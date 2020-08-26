//
//  SearchResaultView.swift
//  搜索结果
//  Whisper
//
//  Created by WeeStar on 2020/8/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SearchResaultView: View {
    @Binding var isSearching:Bool
    @Binding var searchKeyWords:String
    
    var musicSourcSeq:[MusicSource] = ConfigDataService.configIns.musicSourcSeq
        .filter({(m) -> Bool in return m != MusicSource.Bilibili
        && m != MusicSource.Xiami })
    
    @State private var selSourceIdx = 0
    @State private var searchingSourceIdx = -1
    @State private var searchRes = [0:[MusicModel](),1:[MusicModel](),2:[MusicModel](),
                                    3:[MusicModel](),4:[MusicModel]()]
    
    var body: some View {
        VStack{
            //类型选择
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .bottom, spacing: 8){
                    ForEach(0..<self.musicSourcSeq.count,id:\.self) {i in
                        Text(Utility.musicSourceFormat(source: self.musicSourcSeq[i]))
                            .frame(minWidth:CGFloat(Utility.musicSourceFormat(source: self.musicSourcSeq[i]).count) * 20)
                            .foregroundColor(self.selSourceIdx == i ? Color("textColorMain") : Color("textColorSub"))
                            .font(.system(size:18, weight: self.selSourceIdx == i ? Font.Weight.bold : Font.Weight.regular))
                            .background(Color(.white).opacity(0.001))
                            .buttonStyle(PlainButtonStyle())
                            .onTapGesture {
                                self.selSourceIdx = i
                                
                                // 正在搜索本项 不进行搜索
                                if(self.searchingSourceIdx == self.selSourceIdx){
                                    return
                                }
                                
                                // 已有数据 不进行搜索
                                if(self.searchRes[self.selSourceIdx]!.count > 0){
                                    return
                                }
                                
                                // 点击进行搜索
                                self.search()
                        }
                    }
                }
                .frame(height:27)
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            
            // 搜索结果
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment: .leading){
                    ForEach(self.searchRes[self.selSourceIdx]!, id: \.self) { resItem in
                        SearchMusicResItem(music: resItem)
                            .onTapGesture {
                                if(!resItem.isPlayable()){
                                    // 不可播放的点击没反应
                                    return
                                }
                                self.searchKeyWords = ""
                                self.isSearching = false
                                WhisperPlayer.shareIns.newMusic(playMusic: resItem)
                        }
                        .contextMenu(menuItems: {
                            Button(action: {
                                if(!resItem.isPlayable()){
                                    // 不可播放的点击没反应
                                    return
                                }
                                WhisperPlayer.shareIns.newMusic(playMusic: resItem)
                            })
                            {
                                Text("插入并播放")
                                Image(systemName: "play.circle").font(.system(size: 25))
                            }
                            
                            Button(action: {
                                if(!resItem.isPlayable()){
                                    // 不可播放的点击没反应
                                    return
                                }
                                WhisperPlayer.shareIns.newMusic(playMusic: resItem,nextPlay: true)
                            })
                            {
                                Text("下一首播放")
                                Image(systemName: "increase.indent").font(.system(size: 25))
                            }
                        })
                    }
                    
                    if(self.searchingSourceIdx == self.selSourceIdx){
                        HStack(alignment:.center){
                            Spacer()
                            Text("正在加载...")
                                .foregroundColor(Color("textColorSub"))
                                .font(.footnote)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    
                    Spacer(minLength: 0)
                }
                .frame(width:UIScreen.main.bounds.width)
            }
            .padding(.leading,15)
        }
        .background(Color("bgColorMain"))
        .onAppear(perform: {
            self.search()
        })
        .onDisappear(perform: {
            self.clearSearchRes()
        })
    }
    
    private func search() {
        // 标记请求类型
        self.searchingSourceIdx = self.selSourceIdx
        
        //请求数据
        ApiService.SearchMusic(source: self.musicSourcSeq[self.searchingSourceIdx],
                               searchKeyWords: self.searchKeyWords,
                               completeHandler: { res in
                                // 请求结果赋值
                                self.searchRes[self.searchingSourceIdx] = res
                                
                                //取消请求类型
                                self.searchingSourceIdx = -1
        })
    }
    
    private func clearSearchRes(){
        self.searchRes = [0:[MusicModel](),1:[MusicModel](),2:[MusicModel](),
                          3:[MusicModel](),4:[MusicModel]()]
    }
}
