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
    //歌单数据
    @ObservedObject var hisObj:HisDataService
    @ObservedObject var mySheetsObj:MySheetsDataService
    @State private var tabSelIdx = 0
    @State private var showActionSheet = false
    @State private var showTextAlert = false
    
    init(){
        self.hisObj = HisDataService.shareIns
        self.mySheetsObj = MySheetsDataService.shareIns
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment:.leading) {
                    Divider()
                        .foregroundColor(Color("textColorSub").opacity(0.5))
                        .padding(.leading,15)
                    
                    if(self.hisObj.hisSheets.count>0){
                        //最近播放部分
                        VStack(alignment:.leading){
                            //标题
                            Text("最近播放")
                                .font(.system(size: 20, weight:Font.Weight.bold, design: .default))
                                .foregroundColor(Color("textColorMain"))
                                .padding(.leading,2)
                            
                            //歌单列表
                            ScrollView(.horizontal,showsIndicators: false) {
                                HStack(alignment: .top, spacing: 13) {
                                    ForEach(self.hisObj.hisData.playSheetHis, id: \.self) { sheet in
                                        SheetBlockView(sheet:sheet)
                                    }
                                }
                                .frame(height: 150)
                            }
                            
                            Divider()
                                .foregroundColor(Color("textColorSub").opacity(0.5))
                        }
                        .padding(.leading,15)
                        .padding(.top,5)
                    }
                    
                    //我的歌单部分
                    VStack(alignment: .leading){
                        HStack(alignment: .bottom, spacing: 8){
                            Text("我的收藏")
                                .font(.system(size: 20, weight:Font.Weight.bold, design: .default))
                                .foregroundColor(self.tabSelIdx == 0 ? Color("textColorMain") : Color("textColorSub"))
                                .padding(.leading,2)
                                .frame(minWidth:90,alignment: .leading)
                                .background(Color(.white).opacity(0.001))
                                .buttonStyle(PlainButtonStyle())
                                .onTapGesture {
                                    if(self.tabSelIdx != 0){
                                        self.tabSelIdx = 0
                                    }
                            }
                            
                            Text("我的歌单")
                                .font(.system(size: 20, weight:Font.Weight.bold, design: .default))
                                .foregroundColor(self.tabSelIdx == 1 ? Color("textColorMain") : Color("textColorSub"))
                                .padding(.leading,2)
                                .frame(minWidth:90,alignment: .leading)
                                .background(Color(.white).opacity(0.001))
                                .buttonStyle(PlainButtonStyle())
                                .onTapGesture {
                                    if(self.tabSelIdx != 1){
                                        self.tabSelIdx = 1
                                    }
                            }
                            
                            Spacer()
                        }
                        
                        if(self.tabSelIdx == 0){
                            ForEach(self.mySheetsObj.favSheets, id: \.self) { sheet in
                                SheetBarView(sheet:sheet)
                            }
                        }
                        else{
                            ForEach(self.mySheetsObj.mySheets, id: \.self) { sheet in
                                SheetBarView(sheet:sheet)
                            }
                        }
                    }
                    .padding(.leading,15)
                    .padding(.top,5)
                }
                    .padding(.bottom,116)//让出底部tab和播放器空间
            }
            .navigationBarTitle(Text("我的歌单"))
            .navigationBarItems(trailing:
                Button(action:{
                    self.showTextAlert = true
                }){
                    Text("添加歌单").font(.subheadline).foregroundColor(Color("ThemeColorMain"))
                }
            )
        }
            .actionSheet(isPresented: self.$showActionSheet, content: { //此处为ActionSheet的文本与事件
                ActionSheet(title:Text("添加歌单").font(.headline),
                            buttons: [
                                .default(Text("从外部导入"), action: {
                                    self.showTextAlert = true
                                }),
                                .default(Text("新建歌单"), action: {
                                    
                                }),
                                .destructive(Text("Cancel"), action: {
                                    self.showActionSheet = false
                                })
                ])
            })
            .showTextAlert(title: "导入歌单歌单", desc: "在浏览器中复制歌单链接，并在此输入",palaceHolder: "请输入外部歌单链接",isPresented: self.$showTextAlert,
                           successHandler: { inputText in
                            print(inputText)
            })
    }
}
