//
//  SheetBarView.swift
//  条状歌单
//  Whisper
//
//  Created by WeeStar on 2020/6/17.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 条状歌单
struct SheetBarView: View {
    var sheet:SheetModel
    @State private var isNaviLinkActive = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack{
            NavigationLink(destination: SheetInfoView(sheetId: self.sheet.id,source: self.sheet.sheet_source),
                           isActive:self.$isNaviLinkActive){
                            EmptyView()
            }
            
            HStack(){
                //歌单封面logo
                WebImageView(self.sheet.cover_img_url, renderingMode: .original,qulity: .Low)
                    .cornerRadius(10)
                    .frame(width:60,height: 60)
                
                VStack(alignment: .leading, spacing: 5){
                    //歌单标题
                    Text(self.sheet.title)
                        .foregroundColor(Color("textColorMain"))
                        .lineLimit(2)
                    if(self.sheet.tracks.count > 0){
                        Text(String(self.sheet.tracks.count)+" 首")
                            .foregroundColor(Color("textColorSub"))
                            .lineLimit(1)
                            .font(.subheadline)
                    }
                    else{
                        HStack(spacing:3){
                            //来源种类
                            Image(self.sheet.sheet_source.rawValue).renderingMode(.original)
                                .resizable()
                                .frame(width: 15, height: 15)
                            
                            Text(Utility.musicSourceFormat(source: self.sheet.sheet_source))
                                .font(.subheadline)
                                .foregroundColor(Color("textColorSub"))
                        }
                    }
                }
                Spacer()
            }
            .background(Color(.white).opacity(0.001))
            .onTapGesture{
                self.isNaviLinkActive.toggle()
            }
        }
        .contextMenu(menuItems: {
            Button(action: {
                if(self.sheet.is_my && self.sheet.tracks.count == 0){
                    return
                }
                if(self.sheet.tracks.count>0){
                    WhisperPlayer.shareIns.newSheet(playSheet: self.sheet)
                    return
                }
                ApiService.GetSheetInfo(source: self.sheet.sheet_source, sheetId: self.sheet.id, completeHandler: {sheetData in
                    WhisperPlayer.shareIns.newSheet(playSheet: sheetData)
                })
            })
            {
                Text("播放歌单")
                Image(systemName: "play.circle").font(.system(size: 25))
            }
            if(self.sheet.is_my){
                Button(action: {
                    Thread.init{
                        Thread.sleep(forTimeInterval: 0.2)
                        DispatchQueue.main.async {
                            self.showAlert = true
                        }
                    }.start()
                })
                {
                    Text("删除歌单")
                    Image(systemName: "trash").font(.system(size: 25))
                }
            }
            else{
                Button(action: {
                    Thread.init{
                        Thread.sleep(forTimeInterval: 0.2)
                        DispatchQueue.main.async {
                            self.showAlert = true
                        }
                    }.start()
                })
                {
                    Text("取消收藏")
                    Image(systemName: "star.slash").font(.system(size: 25))
                }
            }
        })
            
            .alert(isPresented: self.$showAlert) {
                if(self.sheet.is_my){
                    return Alert(title: Text("删除歌单"),
                                 message: Text("删除操作不可恢复，是否删除歌单？"),
                                 primaryButton: .default(Text("确定")){
                                    // 清空历史
                                    MySheetsDataService.shareIns.DelMySheet(sheetId: self.sheet.id)
                        },
                                 secondaryButton: .default(Text("取消")){
                        })
                }
                else{
                    return Alert(title: Text("取消收藏"),
                                 message: Text("是否取消收藏歌单？"),
                                 primaryButton: .default(Text("确定")){
                                    // 清空历史
                                    MySheetsDataService.shareIns.DelFavSheet(sheetId: self.sheet.id)
                        },
                                 secondaryButton: .default(Text("取消")){
                        })
                }
        }
    }
}

struct SheetBarView_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        sheet.sheet_source = MusicSource.Netease
        
        return SheetBarView(sheet:sheet )
    }
}
