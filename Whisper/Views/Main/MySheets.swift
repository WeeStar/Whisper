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
struct MySheets: View {
    init(mySheets:[SheetModel]) {
        self.mySheets=mySheets
    }
    
    //我的歌单
    private var mySheets=[SheetModel]()
    
    var body: some View {
        NavigationView {
            List {
                //最近播放部分
                VStack(alignment:.leading){
                    //标题
                    Text("最近播放")
                        .foregroundColor(Color("textColorMain"))
                        .font(.headline)
                        .padding(.top, 5)
                    
                    //歌单列表
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack(alignment: .top, spacing: 13) {
                            ForEach(self.mySheets, id: \.self) { sheet in
                                SheetBlockView(sheetTitle: sheet.title, tracksCount: sheet.tracks.count, coverImgUrl: sheet.cover_img_url)
                            }
                        }
                    }
                    .frame(height: 160)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 15, bottom: 0, trailing: 0))
                
                //我的歌单部分
                VStack(alignment: .leading,spacing: 12){
                    Text("我的歌单")
                        .foregroundColor(Color("textColorMain"))
                        .font(.headline)
                        .padding(.top, 5)
                    
                    ForEach(self.mySheets, id: \.self) { sheet in
                        SheetBarView(sheetTitle: sheet.title, tracksCount: sheet.tracks.count, coverImgUrl: sheet.cover_img_url)
                    }
                }
            }
            .navigationBarTitle(Text("我的歌单")
            .foregroundColor(Color("textColorMain"))
                ,displayMode:.automatic)
        }
        .background(Color("bgColorMain"))
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
        
        mySheets.append(sheet1)
        mySheets.append(sheet1)
        mySheets.append(sheet1)
        mySheets.append(sheet1)
        mySheets.append(sheet1)
        mySheets.append(sheet2)
        
        return MySheets(mySheets:mySheets)
    }
}
