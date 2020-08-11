//
//  SheetListView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/6.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SheetListView: View {
    public var source:MusicSource
    @State public var items: [SheetModel]
    @State public var hasMore:Bool
    @State private var isLoading: Bool = false
    @State private var page: Int = 2
    
    var body: some View {
        List{
            ForEach(self.items, id: \.self) { item in
                // 推荐歌单条
                SheetRecomView(sheet:item, widthScale: 0.95)
                    .onAppear {
                        self.loadMoreDatas(item)
                }
            }
            VStack{
                if !self.hasMore{
                    Text("/有时候有时候/我会相信一切有尽头/")
                        .foregroundColor(Color("textColorSub"))
                        .font(.footnote)
                        .padding(.vertical)
                }
                else if self.isLoading {
                    Text("/我为什么/还在等待/")
                        .foregroundColor(Color("textColorSub"))
                        .font(.footnote)
                        .padding(.vertical)
                }
            }
        }
            .padding(.bottom,116)//让出底部tab和播放器空间
            .navigationBarTitle(Utility.musicSourceFormat(source: self.source))
    }
}

extension SheetListView {
    /// 向后加载数据
    private func loadMoreDatas<Item: Identifiable>(_ item: Item) {
        //无更多 或 非最后一条 跳出
        if !self.hasMore || !self.items.isThresholdItem(offset: 5, item: item)
        {
            return
        }
        
        //开始加载数据
        self.isLoading = true
        
        //调用接口获取推荐歌单
        HttpService.Get(module: "music", methodUrl: "hot_sheets", musicSource: self.source,params: ["page_index":self.page],
                        successHandler: { resData in
                            // 加载结束
                            self.page += 1
                            self.isLoading = false
                            
                            //处理返回数据
                            let resArr = resData as? NSArray
                            // 空值处理
                            if(resArr == nil){
                                self.hasMore=false//无更多
                                return
                            }
                            let sheets=[SheetModel].deserialize(from: resArr)
                            if(sheets == nil || sheets!.count == 0){
                                self.hasMore=false//无更多
                                return
                            }
                            self.items.append(contentsOf: (sheets as! [SheetModel]))
                            
                            //数量不够 也无更多
                            if(sheets!.count < RecomService.pageSize){
                                self.hasMore=false//无更多
                                return
                            }
        },
                        failHandler: {errorMsg in
                            //接口请求错误
                            self.isLoading = false
                            self.hasMore=false//无更多
        })
    }
}
