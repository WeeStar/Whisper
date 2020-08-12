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
    @State private var sheetInfo:SheetModel = SheetModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing:0){
                //封面
                SheetCover(sheetTitle: sheetInfo.title ?? "", sheetDesc:sheetInfo.description, tracksCount: sheetInfo.tracks.count, coverImgUrl: sheetInfo.cover_img_url ?? "")
                
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
                        Spacer()
                    }
                    .padding(.top,15)
                    .padding(.bottom,5)
                    .padding(.leading,15)
                    
                    //列表信息
                    ForEach(0..<self.sheetInfo.tracks.count,id:\.self) {i in
                        MusicItem(music: self.sheetInfo.tracks[i],musicIdx: i+1)
                    }
                    
                    Text("/有时候有时候/我会相信一切有尽头/")
                    .foregroundColor(Color("textColorSub"))
                    .font(.footnote)
                    .padding()
                    .padding(.bottom,116-UIScreen.main.bounds.width*0.15)
                }
                .background(Color("bgColorMain"))
                .cornerRadius(20)
                .frame(maxWidth:.infinity, minHeight: 350, alignment: .leading)
                .offset(y:-20)
            }
            .offset(y: -UIScreen.main.bounds.width*0.15)
        }
        .background(Color("bgColorMain"))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear(perform: {
            ApiService.GetSheetInfo(source: self.source, sheetId: self.sheetId, completeHandler: {sheet in
                self.sheetInfo = sheet
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
