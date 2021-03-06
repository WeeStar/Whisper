//
//  SearchHisView.swift
//  搜索历史
//  Whisper
//
//  Created by WeeStar on 2020/8/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SearchHisView: View {
    @Binding var isSearching:Bool
    @Binding var searchKeyWords:String
    @ObservedObject var hisObj:HisDataService = HisDataService.shareIns
    @Binding var isDelHis:Bool
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(alignment:.leading,spacing: 0){
                HStack(alignment:.bottom){
                    Text("搜索历史").font(.system(size: 20, weight: Font.Weight.bold))
                    Spacer()
                    
                    HStack(alignment:.bottom){
                        Spacer()
                        Text("清空").font(.system(size: 14))
                            .foregroundColor(Color("textColorSub"))
                        Spacer()
                    }
                    .frame(width:55,height: 20)
                    .background(Color(.white).opacity(0.001))
                    .buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        if(self.hisObj.hisData.searchHis.count == 0){
                            return
                        }
                        self.isDelHis = true
                    }
                    
                }
                .padding(.top,10)
                .padding(.bottom,6)
                
                ForEach(self.hisObj.hisData.searchHis, id: \.self) { sherchHisItem in
                    VStack(alignment:.leading,spacing: 0){
                        Divider()
                            .foregroundColor(Color("textColorSub").opacity(0.5))
                            .frame(height:0.5)
                        
                        HStack{
                            Text(sherchHisItem)
                                .foregroundColor(Color("ThemeColorMain"))
                                .font(.system(size: 19))
                            
                            Spacer()
                        }
                        .background(Color(.white).opacity(0.001))
                        .padding(.top,9)
                        .padding(.bottom,9)
                        .onTapGesture {
                            // 使用历史
                            self.searchKeyWords = sherchHisItem
                            
                            //延时设置搜索 因搜索框聚焦需要时间
                            let thread = Thread.init {
                                Thread.sleep(forTimeInterval: 0.5)
                                DispatchQueue.main.async {
                                    self.isSearching = true
                                    HisDataService.shareIns.AddHis(keyWords: self.searchKeyWords)
                                }
                            }
                            thread.start()
                        }
                    }
                }
            }
            .padding(.horizontal,15)
                .padding(.bottom,116)//让出底部tab和播放器空间
        }
        .navigationBarTitle("搜索歌曲")
    }
}

