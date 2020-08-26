//
//  SheetRecomView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/3.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SheetRecomView: View {
    //歌单相关信息
    var sheet:SheetModel
    var widthScale:CGFloat
    var isInList:Bool
    
    @State private var isNaviLinkActive = false
    
    var body: some View {
        ZStack{
            NavigationLink(destination:SheetInfoView(sheetId: self.sheet.id,source: self.sheet.sheet_source),
                           isActive:self.$isNaviLinkActive){
                EmptyView()
            }
            
            HStack(){
                //歌单封面logo
                WebImageView(self.sheet.cover_img_url,renderingMode: .original,qulity:ImageQulity.Low)
                    .cornerRadius(10)
                    .frame(width:60,height: 60)
                    .overlay(
                        //边框
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .stroke(Color("textColorSub"), lineWidth: 0.3)
                    )
                
                VStack(alignment: .leading, spacing: 5){
                    //歌单标题
                    Text(self.sheet.title)
                        .foregroundColor(Color("textColorMain"))
                        .lineLimit(1)
                    HStack(spacing:5){
                        Image(systemName:"play")
                            .resizable()
                            .foregroundColor(Color("textColorSub"))
                            .padding(.leading,2)
                            .frame(width:14,height: 14)
                        Text(Utility.playNumsFormat(play: self.sheet.play) + " 次播放")
                            .foregroundColor(Color("textColorSub"))
                            .lineLimit(1)
                            .font(.subheadline)
                    }
                }
                Spacer()
            }
            .padding(.leading,self.isInList ? 0 : 2)
            .padding(.vertical,self.isInList ? 0 : 5)
            .onTapGesture{
                self.isNaviLinkActive.toggle()
            }
        }
        .frame(width:UIScreen.main.bounds.width*self.widthScale)
        .contextMenu(menuItems: {
            Button(action: {
                ApiService.GetSheetInfo(source: self.sheet.sheet_source, sheetId: self.sheet.id, completeHandler: {sheetData in
                    WhisperPlayer.shareIns.newSheet(playSheet: sheetData)
                })
            })
            {
                Text("播放歌单")
                Image(systemName: "play.circle").font(.system(size: 25))
            }
            Button(action: {
                MySheetsDataService.shareIns.AddFavSheets(sheet: self.sheet)
                //todo ： 弹提示
            })
            {
                Text("收藏歌单")
                Image(systemName: "star").font(.system(size: 25))
            }
        })
    }
}

struct SheetRecomView_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        return SheetRecomView(sheet: sheet,widthScale:0.9,isInList: true)
    }
}
