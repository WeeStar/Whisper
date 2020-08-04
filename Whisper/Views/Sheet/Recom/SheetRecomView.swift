//
//  SheetRecomView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/3.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SheetRecomView: View {
    //封面相关信息
    private var sheetTitle:String
    private var play:String
    private var coverImgUrl:String
    
    /// 条状歌单
    /// - Parameters:
    ///   - sheetTitle: 歌单标题
    ///   - tracksCount: 歌曲数量
    ///   - coverImgUrl: 封面图片Url
    init(sheetTitle:String,play:String,coverImgUrl:String) {
        self.sheetTitle = sheetTitle
        self.play = play
        self.coverImgUrl=coverImgUrl
    }
    
    var body: some View {
        HStack(){
            //歌单封面logo
            WebImageView(self.coverImgUrl,renderingMode: .original,qulity:ImageQulity.Low)
                .cornerRadius(10)
                .frame(width:60,height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .circular)
                        .stroke(Color("textColorSub"), lineWidth: 0.3)
            )
            
            VStack(alignment: .leading, spacing: 5){
                //歌单标题
                Text(sheetTitle)
                    .foregroundColor(Color("textColorMain"))
                    .lineLimit(1)
                HStack(spacing:5){
                    Image(systemName:"play")
                        .resizable()
                        .foregroundColor(Color("textColorSub"))
                        .padding(.leading,2)
                    .frame(width:14,height: 14)
                    Text(Utility.playNumsFormat(play: self.play) + " 次播放")
                    .foregroundColor(Color("textColorSub"))
                    .lineLimit(1)
                    .font(.subheadline)
                }
                
            }
            Spacer()
        }
        .frame(width:UIScreen.main.bounds.width*0.9)
    }
}

struct SheetRecomView_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        return SheetRecomView(sheetTitle:"歌单名称歌名称",play:"123",coverImgUrl:sheet.cover_img_url)
    }
}
