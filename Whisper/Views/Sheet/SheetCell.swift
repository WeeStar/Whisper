//
//  SheetCell.swift
//  块状歌单
//  Whisper
//
//  Created by WeeStar on 2020/6/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SheetCell: View {
    //封面相关信息
    private var sheetTitle:String
    private var tracksCount:Int
    private var coverImgUrl:String
    
    /// 块状歌单
    /// - Parameters:
    ///   - sheetTitle: 歌单标题
    ///   - tracksCount: 歌曲数量
    ///   - coverImgUrl: 封面图片Url
    init(sheetTitle:String,tracksCount:Int,coverImgUrl:String) {
        self.sheetTitle = sheetTitle
        self.tracksCount = tracksCount
        self.coverImgUrl=coverImgUrl
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .top){
                //歌单封面logo
                WebImageView(self.coverImgUrl)
                    .cornerRadius(10)
                    .frame(width:110,height: 110)
                HStack{
                    Spacer()
                    Text(String(tracksCount)+" 首")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)
                        .padding(.top,3).padding(.trailing,7)
                        .lineLimit(1)
                }
            }
            
            //歌单标题
            Text(sheetTitle)
                .lineLimit(2)
        }
        .frame(width:110)
    }
}

struct SheetCell_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        return SheetCell(sheetTitle:"歌单名称歌单名称歌单名称歌单名称歌单名称歌单名称歌单名称",tracksCount:1,coverImgUrl:sheet.cover_img_url)
    }
}
