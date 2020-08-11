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
    //歌单相关信息
    var sheet:SheetModel
    
    @State private var isNaviLinkActive=false
    
    var body: some View {
        ZStack{
            NavigationLink(destination:SheetInfoView(sheet: sheet),isActive:self.$isNaviLinkActive){
                EmptyView()
            }
            
            ZStack(alignment: .top){
                //歌单封面logo
                WebImageView(self.sheet.ori_cover_img_url,renderingMode: .original,qulity:ImageQulity.Regular)
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Spacer()
                        Image(systemName:"play")
                            .resizable()
                            .foregroundColor(Color("textColorOnImg"))
                            .padding(.leading,2)
                            .frame(width:14,height: 14)
                        
                        Text(Utility.playNumsFormat(play: self.sheet.play) + " 次播放")
                            .foregroundColor(Color("textColorOnImg"))
                            .lineLimit(1)
                            .font(.system(size: 14, weight:.medium))
                    }
                    .padding(.top,10)
                    .padding(.trailing,10)
                    
                    Spacer()
                    HStack(){
                        VStack(alignment: .leading,spacing: 0){
                            HStack(spacing:3){
                                //来源种类
                                Image(self.sheet.sheet_source!.rawValue).renderingMode(.original)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                
                                Text(Utility.musicSourceFormat(source: self.sheet.sheet_source))
                                    .font(.footnote)
                                    .foregroundColor(Color("textColorOnImg"))
                            }
                            .padding(.leading,15)
                            .padding(.vertical,4)
                            
                            //下方歌单标题
                            Text(self.sheet.title != "" ? self.sheet.title : "暂无歌单信息")
                                .lineLimit(2)
                                .foregroundColor(Color("textColorOnImg"))
                                .font(.system(size: 16, weight: .heavy))
                                .padding(.horizontal,15)
                                .padding(.bottom,10)
                            
                            Spacer(minLength: 0)
                        }
                        Spacer(minLength: 0)
                    }
                    .frame(height:75)
                    .background(BlurView(.systemUltraThinMaterial))
                }
            }
            .onTapGesture{
                self.isNaviLinkActive.toggle()
            }
        }
        .frame(width:UIScreen.main.bounds.width*0.8,height: UIScreen.main.bounds.width*0.8)
        .cornerRadius(10)
    }
}

struct SheetBigView_Previews: PreviewProvider {
    static var previews: some View {
        let sheet=SheetModel()
        sheet.sheet_source = MusicSource.Netease
        sheet.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet.title="深夜摩的深夜摩的深夜摩的深夜摩的深夜摩的深夜摩的深夜摩的深夜摩的深夜摩的深夜摩的"
        sheet.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        return SheetBigView(sheet: sheet)
    }
}
