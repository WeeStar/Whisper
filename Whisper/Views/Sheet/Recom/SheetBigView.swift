//
//  SheetBannerView.swift
//  歌单跑马灯
//  Whisper
//
//  Created by WeeStar on 2020/6/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 大图块状歌单
struct SheetBigView: View {
    //封面相关信息
     var sheetTitle:String
     var coverImgUrl:String
    
    var body: some View {
        ZStack(alignment: .top){
            //歌单封面logo
            WebImageView(self.coverImgUrl,renderingMode: .original)
                .cornerRadius(10)
                .scaledToFit()
            
            VStack(alignment: .trailing, spacing: 10){
                Spacer()
                HStack{
                    //下方歌单标题
                    Text(self.sheetTitle != "" ? self.sheetTitle : "暂无歌单信息")
                    .lineLimit(2)
                        .foregroundColor(Color("textColorOnImg"))
                        .font(.subheadline)
                    Spacer(minLength: 0)
                }
                .padding(15)
                .padding(.bottom,5)
            }
            .frame(width:UIScreen.main.bounds.width*0.8)
        }
        .frame(width:UIScreen.main.bounds.width*0.8,
        height: UIScreen.main.bounds.width*0.8)
    }
}

struct SheetBigView_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        return SheetBigView(sheetTitle:"歌单名称歌名称歌名称歌名称歌名称歌名称歌单歌单名称",coverImgUrl:sheet.cover_img_url)
    }
}
