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
    var nowDate:String
    
    init(){
//        let today = Date()
//        let zone = NSTimeZone.system
//        let interval = zone.secondsFromGMT()
//        let now = today.addingTimeInterval(TimeInterval(interval))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "M月d日"// 自定义时间格式

        self.nowDate = dateformatter.string(from: Date())
    }
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack{
                    Rectangle()
                        .foregroundColor(Color("textColorSub").opacity(0.5))
                        .frame(height:0.5)
                        .padding(.leading,15)
                    
                    SheetBannerView(pageDatas: RecomService.bannerSheets, tapCallBack: { index in
                        print(index)
                    })
                        .padding(.top)
                        .padding(.bottom)
                        .listRowInsets(EdgeInsets())
                    
                    ForEach(RecomService.recomSheets, id: \.self) { dicItem in
                        Group{
                            Rectangle()
                                .foregroundColor(Color("textColorSub").opacity(0.5))
                                .frame(height:0.5)
                            
                            RecomChildView(source: dicItem.source, sheets: dicItem.sheets)
                                .padding(.top,5)
                        }
                        .padding(.leading,15)
                    }
                }
                .padding(.bottom,50)
            }
            .navigationBarItems(leading: Text(self.nowDate).font(.subheadline).foregroundColor(Color("textColorSub")))
            .navigationBarTitle(Text("推荐歌单").foregroundColor(Color("textColorMain")))
//            .sheet(isPresented: $showDate) {
//                           Text("User Profile")
//                       }
        }
        .background(Color("bgColorMain"))
    }
}

struct RecomChildView: View {
    var source:MusicSource
    var sheets:[SheetModel]
    var sheetsByThree:[[SheetModel]]
    var title:String
    
    init(source:MusicSource,sheets:[SheetModel]){
        self.source=source
        self.sheets=sheets
        switch source{
        case .Netease:
            self.title="网易云音乐"
            break
        case .Tencent:
            self.title="QQ音乐"
            break
        case .Bilibili:
            self.title="Bilibili音乐"
            break
        case .Xiami:
            self.title="虾米音乐"
            break
        case .Migu:
            self.title="咪咕音乐"
            break
        case .Kugou:
            self.title="酷狗音乐"
            break
        default:
            self.title="未知"
            break
        }
        
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
                Text(self.title).font(.system(size: 20, weight:Font.Weight.bold, design: .default))
                    .foregroundColor(Color("textColorMain"))
                
                Spacer()
                
                Text("查看更多").font(.subheadline)
                    .foregroundColor(Color("ThemeColorMain"))
                    .padding(.trailing)
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack{
                    ForEach(self.sheetsByThree, id: \.self) { sheetsGroup in
                        VStack{
                            ForEach(sheetsGroup, id: \.self) { sheet in
                                SheetRecomView(sheetTitle: sheet.title, play: sheet.play, coverImgUrl: sheet.cover_img_url)
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


