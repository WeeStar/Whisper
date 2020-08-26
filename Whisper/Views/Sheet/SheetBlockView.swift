//
//  SheetBlockView.swift
//  块状歌单
//  Whisper
//
//  Created by WeeStar on 2020/6/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 块状歌单
struct SheetBlockView: View {
    var sheet:SheetModel
    @State private var isNaviLinkActive = false
    
    var body: some View {
        ZStack{
            NavigationLink(destination: SheetInfoView(sheetId: self.sheet.id,source: self.sheet.sheet_source),
                           isActive:self.$isNaviLinkActive){
                            EmptyView()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .top){
                    //歌单封面logo
                    WebImageView(self.sheet.cover_img_url,renderingMode: .original,qulity:.Low)
                        .cornerRadius(10)
                        .frame(width:90,height: 90)
                    
                    HStack{
                        //来源种类
                        Image(self.sheet.sheet_source!.rawValue).renderingMode(.original)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.top,3).padding(.leading,3)
                        
                        Spacer()
                    }
                }
                
                //歌单标题
                Text(self.sheet.title)
                    .foregroundColor(Color("textColorMain"))
                    .font(.subheadline)
                    .lineLimit(2)
                
                Spacer(minLength:0)
            }
            .background(Color(.white).opacity(0.001))
            .onTapGesture{
                self.isNaviLinkActive.toggle()
            }
        }
        .frame(width:90,height:150)
        .contextMenu(menuItems: {
            Button(action: {
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
        })
    }
}

struct SheetCell_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的深夜摩的深夜摩的深夜摩的"
        sheet.sheet_source = MusicSource.Netease
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        return SheetBlockView(sheet:sheet)
    }
}
