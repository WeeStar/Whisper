//
//  MySheets.swift
//  我的歌单
//  Whisper
//
//  Created by WeeStar on 2020/6/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

/// 我的歌单
struct MySheetsView: View {
    @State private  var searchKeyWords = ""
    init(mySheets:[SheetModel]) {
        self.mySheets=mySheets
    }
    
    //我的歌单
    private var mySheets=[SheetModel]()
    
    var body: some View {
        NavigationView {
//            VStack(alignment:.leading) {
////                //最近播放部分
////                VStack(alignment:.leading){
////                    //标题
////                    Text("最近播放")
////                        .foregroundColor(Color("textColorMain"))
////                        .font(.headline)
////                        .padding(.top, 5)
////
////                    //歌单列表
////                    ScrollView(.horizontal,showsIndicators: false) {
////                        HStack(alignment: .top, spacing: 13) {
////                            ForEach(self.mySheets, id: \.self) { sheet in
////                                NavigationLink(destination: SheetInfoView(sheet: sheet)){
////                                    SheetBlockView(sheetTitle: sheet.title, tracksCount: sheet.tracks.count, coverImgUrl: sheet.cover_img_url)
////                                }
////                            }
////                        }
////                    }
////                    .frame(height: 160)
////                }
////                .padding(.leading,15)
////                .padding(.top,8)
//
////                //我的歌单部分
////                VStack(alignment: .leading,spacing: 12){
////                    Text("我的歌单")
////                        .foregroundColor(Color("textColorMain"))
////                        .font(.headline)
////                        .padding(.top, 5)
////
////                    ForEach(self.mySheets, id: \.self) { sheet in
////                        SheetBarView(sheetTitle: sheet.title, tracksCount: sheet.tracks.count, coverImgUrl: sheet.cover_img_url)
////                    }
////                }
////                .padding(.leading,15)
//
//            }
            List{
                TextField("abc", text: self.$searchKeyWords)
                   .frame(height:30)
                ForEach(self.mySheets, id: \.self) { sheet in
                    SheetBarView(sheetTitle: sheet.title, tracksCount: sheet.tracks.count, coverImgUrl: sheet.cover_img_url)
                }
            }
            .background(Color(.gray))
            .navigationBarTitle(Text("我的歌单"))
            Spacer()
        }
    }
}


struct MySheets_Previews: PreviewProvider {
    static var previews: some View {
        
        var mySheets=[SheetModel]()
        
        let sheet1=SheetModel()
        sheet1.id="myplaylist_8036fa8e-156f-6d6a-f726-1d039621b03b"
        sheet1.title="深夜摩的"
        sheet1.source_url="http://music.163.com/#/playlist?id=911571004"
        sheet1.cover_img_url="http://p2.music.126.net/LltYYgLmmn-8SBlALea1bg==/18972073137599852.jpg"
        
        let sheet2=SheetModel()
        sheet2.id="myplaylist_23da2a04-caf6-daaa-79e9-0a9f801b70d7"
        sheet2.title="春日限定｜香草味恋爱气泡水ฅ"
        sheet2.source_url="http://music.163.com/#/playlist?id=740915547"
        sheet2.cover_img_url="http://p2.music.126.net/O5Vw9yfWGc1EnkENhym3qg==/109951164843664893.jpg"
        
        
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
        
        sheet1.tracks=[music1,music2]
        sheet2.tracks=[music1,music2]
        
        mySheets.append(sheet1)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        mySheets.append(sheet2)
        
        return MySheetsView(mySheets:mySheets)
    }
}
