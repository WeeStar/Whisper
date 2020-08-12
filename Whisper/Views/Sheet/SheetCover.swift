//
//  SheetCover.swift
//  歌单封面
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 歌单封面
struct SheetCover: View {
    //封面相关信息
    private var sheetTitle:String
    private var sheetDesc:String?
    private var tracksCount:Int
    private var coverImgUrl:String
    private var coverImg:WebImageView
    
    /// 初始化
    /// - Parameters:
    ///   - sheetTitle: 歌单标题
    ///   - tracksCount: 歌单歌曲数量
    ///   - coverImgUrl: 歌单封面图片Url
    init(sheetTitle:String,sheetDesc:String?,tracksCount:Int,coverImgUrl:String) {
        self.sheetTitle = sheetTitle
        self.sheetDesc = sheetDesc
        self.tracksCount = tracksCount
        self.coverImgUrl=coverImgUrl
        self.coverImg=WebImageView(self.coverImgUrl,errorImgName: String(arc4random() % 20 + 1))
    }
    
    var body: some View {
        ZStack(alignment:.leading){
            //背景图
            self.coverImg
                .aspectRatio(contentMode: ContentMode.fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            
            //歌单描述
            VStack(spacing:0){
                HStack{
                    //歌单封面logo
                    self.coverImg
                        .cornerRadius(10)
                        .frame(width:110,height: 110).padding()
                    
                    
                    //歌单标题
                    VStack(alignment:.leading,spacing: 10){
                        //标题
                        Text(sheetTitle)
                            .foregroundColor(Color("textColorOnImg"))
                            .font(.headline)
                            .lineLimit(2)
                        
                        //容量
                        Text(String(tracksCount)+"首音乐")
                            .foregroundColor(Color("textColorOnImg"))
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    .frame(height: 90)

                    Spacer()
                }
                .padding(.top,UIScreen.main.bounds.width * 0.3)
                .frame(width: UIScreen.main.bounds.width)
                
                HStack{
                    Text("歌单简介：" + (self.sheetDesc ?? "暂无简介"))
                    .lineLimit(3)
                    .font(.footnote)
                    .foregroundColor(Color("textColorOnImg"))
                    .padding(.horizontal)
                    
                    Spacer()
                }
                Spacer(minLength: 0)
            }
            .background(BlurView(.systemUltraThinMaterial))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
    }
}

struct SheetCover_Previews: PreviewProvider {
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
        
        return  SheetCover(sheetTitle:"歌单单单单单单单单单单单单单单单",sheetDesc: "描述描述描述描述描述描述描述描述描述描述描述描述描述描述",tracksCount:1,coverImgUrl:sheet.cover_img_url)
    }
}
