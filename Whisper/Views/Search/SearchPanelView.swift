//
//  SearchPanelView.swift
//  搜索面板
//  Whisper
//
//  Created by WeeStar on 2020/8/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SearchPanelView: View {
    @Binding var searchKeyWords:String
    @ObservedObject var searchConfig = SearchPanelConfig.shareIns
    @State private var commitSearch:Bool = false
    @State private var searchHis:[String]=ContextService.hisIns.hisList
    

    
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
                    .frame(width:70,height: 20)
                    .background(Color(.white).opacity(0.001))
                    .buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        // 清空历史
                        self.searchHis = ContextService.DelHis()
                    }
                }
                .padding(.top,30)
                .padding(.bottom,6)
                
                ForEach(self.searchHis, id: \.self) { sherchHisItem in
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
                            self.searchHis = ContextService.AddHis(keyWords: self.searchKeyWords)
                            self.commitSearch = true
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom,116)//让出底部tab和播放器空间
        }
    }
}


@objcMembers
class SearchPanelConfig:ObservableObject{
    
    //单例
    static var shareIns = SearchPanelConfig()
    
    //是否展示搜索面板
    @Published var isShowSearchPanel:Bool=false
}
