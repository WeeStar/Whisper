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
        VStack(alignment:.leading){
            //标题
            Text("我的歌单")
            .font(.headline)
            .padding(.leading, 6)
            .padding(.top, 5)
            
            //歌单内容
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.mySheets, id: \.self) { sheet in
                        SheetCell(sheetTitle: sheet.title, tracksCount: sheet.tracks.count, coverImgUrl: sheet.cover_img_url)
                            .padding(.horizontal,6)
                    }
                }
            }
            .frame(height: 185)
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
        
        mySheets.append(sheet1)
        mySheets.append(sheet2)
        
        return MySheets(mySheets:mySheets)
    }
}
