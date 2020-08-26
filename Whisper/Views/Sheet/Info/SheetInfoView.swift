//
//  SheetInfoView.swift
//  歌单页面
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 歌单详情页面
struct SheetInfoView: View {
    /// 音乐信息
    var sheetId:String
    var source:MusicSource
    @State private var isLoading=true
    @State private var sheetInfo:SheetModel = SheetModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing:0){
                //封面
                SheetCover(sheetTitle: sheetInfo.title ?? "", sheetDesc:sheetInfo.description, tracksCount: sheetInfo.tracks.count, coverImgUrl: sheetInfo.cover_img_url ?? "")
                
                VStack(alignment: .leading){
                    Button(action: {
                        WhisperPlayer.shareIns.newSheet(playSheet: self.sheetInfo)
                    })
                    {
                        HStack{
                            Image(systemName: "play.circle")
                                .foregroundColor(Color("textColorSub"))
                                .imageScale(.medium)
                                .frame(width: 18,height: 18)
                                .padding(.trailing,3)
                            Text("播放歌单")
                                .foregroundColor(Color("textColorMain"))
                                .fontWeight(.semibold)
                            Text("("+String(self.sheetInfo.tracks.count)+"首音乐)")
                                .foregroundColor(Color("textColorSub"))
                                .font(.subheadline)
                            Spacer()
                        }
                        .background(Color(.white).opacity(0.001))
                        .padding(.top,15)
                        .padding(.bottom,5)
                        .padding(.leading,15)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    //列表信息
                    ForEach(0..<self.sheetInfo.tracks.count,id:\.self) {i in
                        MusicItem(music: self.sheetInfo.tracks[i],musicIdx: i+1)
                            .onTapGesture {
                                if(!self.sheetInfo.tracks[i].isPlayable()){
                                    // 不可播放的点击没反应
                                    return
                                }
                                WhisperPlayer.shareIns.newSheet(playSheet: self.sheetInfo, playMusicIndex: i)
                        }
                        .contextMenu(menuItems: {
                            Button(action: {
                                if(!self.sheetInfo.tracks[i].isPlayable()){
                                    // 不可播放的点击没反应
                                    return
                                }
                                WhisperPlayer.shareIns.newMusic(playMusic: self.sheetInfo.tracks[i])
                            })
                            {
                                Text("插入并播放")
                                Image(systemName: "play.circle").font(.system(size: 25))
                            }
                            
                            Button(action: {
                                if(!self.sheetInfo.tracks[i].isPlayable()){
                                    // 不可播放的点击没反应
                                    return
                                }
                                WhisperPlayer.shareIns.newMusic(playMusic: self.sheetInfo.tracks[i],nextPlay: true)
                            })
                            {
                                Text("下一首播放")
                                Image(systemName: "increase.indent").font(.system(size: 25))
                            }
                        })
                    }
                    HStack{
                        Spacer()
                        Text(self.isLoading ? "正在加载..." : "/有时候有时候/我会相信一切有尽头/")
                            .foregroundColor(Color("textColorSub"))
                            .font(.footnote)
                            .padding(.top)
                            .padding(.bottom,10)
                            .padding(.bottom,116-UIScreen.main.bounds.width*0.15)
                        Spacer()
                    }
                    
                    Spacer(minLength: 0)
                }
                .background(Color("bgColorMain"))
                .cornerRadius(20)
                .frame(maxWidth:.infinity, minHeight: 350, alignment: .leading)
                .offset(y:-20)
            }
            .offset(y: -UIScreen.main.bounds.width*0.15)
        }
        .edgesIgnoringSafeArea(.all)
//        .navigationViewStyle(DoubleColumnNavigationViewStyle())
//        .navigationBarTitle(Text(self.sheetInfo.title ?? ""))
        .onAppear(perform: {
            //加载本地
            let mySheets = MySheetsDataService.shareIns.mySheetsData.mySheets.first(where: { $0.id == self.sheetId})
            if(mySheets != nil){
                self.sheetInfo = mySheets!
                self.isLoading=false
                return
            }
            //加载网络
            ApiService.GetSheetInfo(source: self.source, sheetId: self.sheetId, completeHandler: {sheet in
                self.sheetInfo = sheet
                self.isLoading=false
            })
        })
    }
}

struct SheetsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let music1=MusicModel()
        music1.id="netrack_500427744"
        
        
        return ForEach(["iPhone SE"], id: \.self) { deviceName in
            SheetInfoView(sheetId: "netrack_500427744", source: MusicSource.Netease).previewDevice(PreviewDevice(rawValue: deviceName)).previewDisplayName(deviceName)
        }
    }
}
