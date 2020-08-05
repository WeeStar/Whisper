//
//  MainTabView.swift
//  主页tab
//  Whisper
//
//  Created by WeeStar on 2020/6/18.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    @State var tabIdx=0
    @State var showPlayerView = false
    var mySheets:[SheetModel]
    var recomView = RecomView()
    var mySheetView:MySheets
    var myView=MyView()
    
    init() {
        self.mySheets=[SheetModel]()
        
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
        mySheets.append(sheet1)
        mySheets.append(sheet1)
        
        self.mySheetView=MySheets(mySheets:self.mySheets)
    }
    
    var body: some View {
        ZStack{
            ZStack{
                //推荐
                self.recomView.zIndex(self.tabIdx==0 ? 10 : 0)
                
                //我的
                self.mySheetView.zIndex(self.tabIdx==1 ? 10 : 0)
                
                //账号
                self.myView.zIndex(self.tabIdx==2 ? 10 : 0)
            }
            //tabbar
            VStack(spacing:0){
                Spacer()
                PlayerBarView(showPlayerView: $showPlayerView, player: WhisperPlayer.shareIns)
                TabBar(tabIdx: $tabIdx)
            }
            VStack(spacing:0){
                PlayerView(showPlayerView: $showPlayerView, player: WhisperPlayer.shareIns)
            }
        }
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

/// tabbar底部条
struct TabBar: View {
    @Binding var tabIdx:Int
    
    private func isTabSelected(idx:Int) -> Bool{
        return tabIdx == idx
    }
    
    var body: some View {
        VStack(spacing:0){
            Rectangle()
                .foregroundColor(Color(.lightGray))
                .frame(height:0.5)
            
            HStack(alignment: .bottom){
                
                //推荐
                TabBarItem(tabIdx: 0, iconCode: "&#xe601;", title: "推荐", selState: self.$tabIdx)
                    .padding(.leading,10)
                
                Spacer()
                
                //我的
                TabBarItem(tabIdx: 1, iconCode: "&#xe65c;", title: "我的", selState: self.$tabIdx)
                
                Spacer()
                
                //账号
                TabBarItem(tabIdx: 2, systemName: "person.fill", title: "账号", selState: self.$tabIdx)
                    .padding(.trailing,10)
            }
            .frame(height:50)
            .background(BlurView(.systemMaterial))
        }.onAppear(perform: {
            //播放内核初始化并播放
            WhisperPlayer.shareIns.reload()
        })
    }
}


/// Tab底部条按钮单项
struct TabBarItem:View {
    
    var tabIdx:Int
    var iconCode:String = ""
    var systemName:String = ""
    var title:String
    @Binding var selState:Int
    
    var isSelected:Bool{
        return selState == self.tabIdx
    }
    
    var body: some View{
        Button(action: {
            if(self.selState != self.tabIdx){
                self.selState = self.tabIdx
            }
        })
        {
            VStack(spacing:2){
                Group{
                    //图标未选中
                    if(iconCode != ""){
                        IconTextView(iconCode: self.iconCode, size: 27)
                    }
                    else{
                        Image(systemName: self.systemName).font(.system(size: 27))
                    }
                }
                .frame(width:27,height: 27)
                .foregroundColor(Color(self.isSelected ? "ThemeColorMain" : "textColorTab"))
                
                //文字
                Text(self.title).font(.system(size: 8))
                    .foregroundColor(Color(self.isSelected ? "ThemeColorMain" : "textColorTab"))
            }
            .frame(width:77,height: 45)
            .background(Color(.white).opacity(0.001))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

