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
    @State private var tabIdx=0
    @State private var showPlayerView = false
    @Environment(\.localStatusBarStyle) var statusBarStyle
    var mySheets:[SheetModel]
    
    //页面初始化
    var recomView:RecomView
    var mySheetView:MySheets
    var searchView=SearchView()
    var playerView = PlayerView()
    
    init() {
        self.recomView = RecomView()
        self.mySheets=[SheetModel]()
        self.mySheetView=MySheets(mySheets:self.mySheets)
    }
    
    var body: some View {
        ZStack{
            //显示页面
            ZStack{
                //推荐
                self.recomView.zIndex(self.tabIdx==0 ? 10 : 1)
                
                //我的
                self.mySheetView.zIndex(self.tabIdx==1 ? 10 : 1)
                
                //账号
                self.searchView.zIndex(self.tabIdx==2 ? 10 : 1)
            }
            //tabbar
            VStack(spacing:0){
                Spacer()
                Divider()
                    .foregroundColor(Color("textColorSub"))
                    .background(Color("textColorSub"))
                
                PlayerBarView(showPlayerView: self.$showPlayerView, player: WhisperPlayer.shareIns)
                
                Divider()
                    .foregroundColor(Color("textColorSub"))
                    .background(Color("textColorSub"))
                
                TabBar(tabIdx: $tabIdx)
            }
        }
        .sheet(isPresented: self.$showPlayerView){
            self.playerView
        }
        .onAppear{
            self.statusBarStyle.currentStyle = .default
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
            HStack(alignment: .bottom){
                
                //推荐
                TabBarItem(tabIdx: 0, iconCode: "&#xe601;", title: "推荐", selState: self.$tabIdx)
                    .padding(.leading,10)
                
                Spacer()
                
                //我的
                TabBarItem(tabIdx: 1, iconCode: "&#xe65c;", title: "我的", selState: self.$tabIdx)
                
                Spacer()
                
                //账号
                TabBarItem(tabIdx: 2, systemName: "magnifyingglass", title: "搜索", selState: self.$tabIdx)
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


class LocalStatusBarStyle{
    fileprivate var getter:() -> UIStatusBarStyle = {.default}
    fileprivate var setter:(UIStatusBarStyle) -> Void = {_ in}
    
    var currentStyle:UIStatusBarStyle{
        get{self.getter()}
        set{self.setter(newValue)}
    }
}

struct LocalStatusBarStyleKey: EnvironmentKey {
    static let defaultValue:LocalStatusBarStyle = LocalStatusBarStyle()
}

extension EnvironmentValues{
    var localStatusBarStyle:LocalStatusBarStyle{
        get{
            return self[LocalStatusBarStyleKey.self]
        }
    }
}


//class MyHostingController <Content> : UIHostingController<Content> where Content: View {
//    private var internalStyle = UIStatusBarStyle.default
//    
//    @objc override dynamic open var preferredStatusBarStyle: UIStatusBarStyle {
//        get {
//            internalStyle
//        }
//        set {
//            internalStyle = newValue
//            self . setNeedsStatusBarAppearanceUpdate()
//        }
//    }
//    override init(rootView: Content) {
//        super.init( rootView: rootView)
//        LocalStatusBarStyleKey.defaultValue.getter = {self.preferredStatusBarStyle}
//        LocalStatusBarStyleKey.defaultValue.setter = {self.preferredStatusBarStyle = $0}
//    }
//    
//    @objc required dynamic init?( coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}

