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
    @State var tabIdx=1
    var mySheets:[SheetModel]
    
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
    }
    
    var body: some View {
        ZStack{
             
            if(self.tabIdx==0){
                //推荐
                RecomView()
            }
            else if(self.tabIdx==1){
                //我的
                MySheets(mySheets:self.mySheets)
            }
            else if(self.tabIdx==2){
                //账号
                MyView()
            }
            
            //tabbar
            TabBar(tabIdx: $tabIdx)
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
        VStack{
            Spacer()
            HStack(alignment: .bottom){
                
                //推荐
                TabBarItem(tabIdx: 0, iconCode: "&#xe681;", title: "推荐", selState: self.$tabIdx)
                    .padding(.leading,40)
                Spacer()
                
                //我的
                TabBarItem(tabIdx: 1, iconCode: "&#xe63a;", title: "我的", selState: self.$tabIdx)
                
                Spacer()
                
                //账号
                TabBarItem(tabIdx: 2, iconCode: "&#xe6c8;", title: "账号", selState: self.$tabIdx)
                    .padding(.trailing,40)
            }
            .frame(height:50)
            .background(BlurView(.systemMaterial))
        }
    }
}


/// Tab底部条按钮单项
struct TabBarItem:View {
    
    var tabIdx:Int
    var iconCode:String
    var title:String
    @Binding var selState:Int
    
    var isSelected:Bool{
        return selState == self.tabIdx
    }
    
    var body: some View{
        VStack(spacing:3){
            Group{
                //图标
                ZStack{
                    //图标选中
                    Circle()
                        .fill(Color("ThemeColorMain"))
                        .overlay(IconTextView(iconCode: self.iconCode, size: 18).foregroundColor(.white))
                        .scaleEffect(self.isSelected ? 1:0.7)
                        .animation(.easeIn(duration: 0.15))
                        .opacity(self.isSelected ? 1:0)
                        .animation(.easeIn(duration: 0.05))
                    
                    //图标未选中
                    IconTextView(iconCode: self.iconCode, size: 25)
                        .foregroundColor(Color("textColorTab").opacity(self.isSelected ? 0:1))
                        .scaleEffect(self.isSelected ? 0.7:1)
                }
                .frame(width: 25,height: 25)
                
                //文字
                Text(self.title).font(.system(size: 10))
                    .foregroundColor(Color(self.isSelected ? "ThemeColorMain" : "textColorTab"))
            }
            .onTapGesture {
                if(self.selState != self.tabIdx){
                    self.selState = self.tabIdx
                }
            }
        }
    }
}
