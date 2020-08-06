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
    init(sheet:SheetModel) {
        self.sheetInfo=sheet
    }
    
    /// 音乐信息
    private var sheetInfo:SheetModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                //封面
                SheetCover(sheetTitle: sheetInfo.title, tracksCount: sheetInfo.tracks.count, coverImgUrl: sheetInfo.cover_img_url)
                    .frame(height: 300)
                
                VStack(alignment: .leading){
                    //播放全部
                    HStack{
                        Image(systemName: "play.circle")
                            .foregroundColor(Color("textColorSub"))
                            .imageScale(.medium)
                            .frame(width: 18,height: 18)
                        Text("播放全部")
                            .foregroundColor(Color("textColorMain"))
                            .fontWeight(.semibold)
                        Text("("+String(self.sheetInfo.tracks.count)+"首音乐)")
                            .foregroundColor(Color("textColorSub"))
                            .font(.subheadline)
                    }
                    .padding(.top,15)
                    .padding(.bottom,5)
                    .padding(.leading,15)
                    
                    //列表信息
                    ForEach(0..<self.sheetInfo.tracks.count,id:\.self) {i in
                        MusicItem(music: self.sheetInfo.tracks[i],musicIdx: i+1)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth:.infinity, minHeight: 500, alignment: .leading)
                .background(Color("bgColorMain"))
                .cornerRadius(20)
                .offset(y:-50)
            }
        }
    }
}

struct SheetsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let music1=MusicModel()
        music1.id="netrack_500427744"
        music1.title="交易"
        music1.artist="N7music"
        music1.album="NiceDay7"
        music1.source=MusicSource.Netease
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
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        sheet.tracks.append(music1)
        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        //        sheet.tracks.append(music2)
        
        
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            SheetInfoView(sheet: sheet).previewDevice(PreviewDevice(rawValue: deviceName)).previewDisplayName(deviceName)
        }
    }
}
