//
//  RecomView.swift
//  推荐页面
//  Whisper
//
//  Created by WeeStar on 2020/6/10.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct RecomView: View {
    var nowDate:String = Utility.chineseTimeFormat(date: Date())
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack{
                    Divider()
                        .foregroundColor(Color("textColorSub").opacity(0.5))
                        .padding(.leading,15)
                    
                    SheetBannerView(bannerDatas: RecomService.bannerSheets, tapCallBack: { index in
                        print(index)
                    })
                        .padding(.vertical)
                        .listRowInsets(EdgeInsets())
                    
                    ForEach(RecomService.recomSheets, id: \.self) { dicItem in
                        Group{
                            Divider()
                                .foregroundColor(Color("textColorSub").opacity(0.5))
                                .frame(height:0.5)
                            
                            RecomChildView(source: dicItem.source, sheets: dicItem.sheets)
                                .padding(.top,5)
                        }
                        .padding(.leading,15)
                    }
                }
                    .padding(.bottom,116)//让出底部tab和播放器空间
            }
            .navigationBarItems(leading: Text(self.nowDate).font(.subheadline).foregroundColor(Color("textColorSub")))
            .navigationBarTitle(Text("推荐歌单").foregroundColor(Color("textColorMain")))
        }
        .background(Color("bgColorMain"))
    }
}

struct RecomChildView: View {
    var source:MusicSource
    var sheets:[SheetModel]
    var sheetsByThree:[[SheetModel]]
    
    init(source:MusicSource,sheets:[SheetModel]){
        self.source=source
        self.sheets=sheets
        
        // 推荐歌单3个一组
        self.sheetsByThree=[[SheetModel]]()
        var sheetsGroup=[SheetModel]()
        for sheet in sheets{
            sheetsGroup.append(sheet)
            if(sheetsGroup.count==3){
                sheetsByThree.append(sheetsGroup)
                sheetsGroup=[SheetModel]()
            }
        }
        if(sheetsGroup.count>0){
            sheetsByThree.append(sheetsGroup)
        }
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                Text(Utility.musicSourceFormat(source: self.source))
                    .font(.system(size: 20, weight:Font.Weight.bold, design: .default))
                    .foregroundColor(Color("textColorMain"))
                
                Spacer()
                
                NavigationLink(destination: SheetListView(source: self.source, items: self.sheets, hasMore: self.sheets.count >= RecomService.pageSize))
                {
                    Text("查看更多").font(.subheadline)
                        .foregroundColor(Color("ThemeColorMain"))
                        .padding(.trailing)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack{
                    ForEach(self.sheetsByThree, id: \.self) { sheetsGroup in
                        VStack{
                            ForEach(sheetsGroup, id: \.self) { sheet in
                                SheetRecomView(sheet: sheet,widthScale: 0.9)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct RecomView_Previews: PreviewProvider {
    static var previews: some View {
        RecomView()
    }
}


