//
//  SearchView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/15.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchConfig = SearchPanelConfig.shareIns
    
    @State private var searchKeyWords:String=""
    @State private var commitSearch:Bool = false
    @State private var searchHis:[String]=ContextService.hisIns.hisList
    
    var body: some View {
        VStack(spacing:0){
            HStack{
                // 搜索框
                VStack(spacing:4){
                    HStack(alignment: .center){
                        Image(systemName: "magnifyingglass").font(.system(size: 20))
                            .foregroundColor(Color("textColorSub"))
                        
                        TextField("请输入搜索关键字", text: self.$searchKeyWords,onCommit: {
                            // 搜索提交
                            if(self.searchKeyWords==""){
                                return
                            }
                            self.searchHis = ContextService.AddHis(keyWords: self.searchKeyWords)
                            self.commitSearch = true
                        })
                            .font(.system(size: 18))
                        
                        if(self.searchKeyWords != ""){
                            Image(systemName: "xmark").font(.system(size: 18))
                                .foregroundColor(Color("textColorSub"))
                                .frame(width:20,height: 18)
                                .background(Color(.white).opacity(0.001))
                                .buttonStyle(PlainButtonStyle())
                                .onTapGesture {
                                    // 清空搜索词
                                    self.searchKeyWords = ""
                                    self.commitSearch = false
                            }
                        }
                    }
                    Divider()
                        .foregroundColor(Color("textColorSub"))
                        .background(Color("textColorSub"))
                }
                .padding(.leading)
                
                Text("取消")
                    .foregroundColor(Color("textColorMain"))
                    .font(.system(size: 18))
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    .background(Color(.white).opacity(0.001))
                    .buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        self.searchKeyWords = ""
                        self.commitSearch = false
                        self.searchConfig.isShowSearchPanel = false
                }
            }
            .padding(.bottom,5)
            .padding(.top,20)
            
            if(!self.commitSearch){
                // 历史记录
                HStack{
                    Text("搜索历史").font(.system(size: 12))
                        .foregroundColor(Color("textColorSub"))
                    
                    Spacer()
                    
                    HStack(spacing:5){
                        Image(systemName: "trash").font(.system(size: 12))
                            .foregroundColor(Color("textColorSub"))
                        Text("清空").font(.system(size: 12))
                            .foregroundColor(Color("textColorSub"))
                    }
                    .background(Color(.white).opacity(0.001))
                    .buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        // 清空历史
                        self.searchHis = ContextService.DelHis()
                    }
                }
                .padding(.horizontal)
                .padding(.top,15)
                .padding(.bottom,10)
                
                ScrollView(.vertical,showsIndicators: false){
                    VStack(spacing:10){
                        ForEach(self.searchHis, id: \.self) { sherchHisItem in
                            VStack(spacing:4){
                                HStack(spacing:0){
                                    HStack{
                                        Text(sherchHisItem)
                                            .foregroundColor(Color("textColorMain"))
                                            .font(.system(size: 16))
                                        
                                        Spacer()
                                    }
                                    .background(Color(.white).opacity(0.001))
                                    .onTapGesture {
                                        // 使用历史
                                        self.searchKeyWords = sherchHisItem
                                        self.searchHis = ContextService.AddHis(keyWords: self.searchKeyWords)
                                        self.commitSearch = true
                                    }
                                    
                                    Image(systemName: "xmark").font(.system(size: 14))
                                        .foregroundColor(Color("textColorMain"))
                                        .frame(width:24,height: 18)
                                        .background(Color(.white).opacity(0.001))
                                        .onTapGesture {
                                            // 删除历史
                                            self.searchHis = ContextService.DelHis(keyWords: sherchHisItem)
                                    }
                                }
                                .padding(.vertical,5)
                                
                                Divider()
                                    .foregroundColor(Color("textColorSub").opacity(0.5))
                                    .frame(height:0.5)
                            }
                                
                            .padding(.horizontal)
                        }
                    }
                }
            }
            else{
                //搜索结果
                SearchResaultView(searchKeyWords: self.$searchKeyWords,commitSearch:self.$commitSearch)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .frame(width:UIScreen.main.bounds.width)
        .background(Color("bgColorMain"))
    }
}


@objcMembers
class SearchPanelConfig:ObservableObject{
    
    //单例
    static var shareIns = SearchPanelConfig()
    
    //是否展示搜索面板
    @Published var isShowSearchPanel:Bool=false
}
