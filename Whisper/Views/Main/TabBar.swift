//
//  TabBar.swift
//  导航栏
//  Whisper
//
//  Created by WeeStar on 2020/6/18.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    
    
    var body: some View {
        ZStack{
            RecomView()
            
            //tabbar
            BarView()
        }
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

struct BarView: View {
    var body: some View {
        VStack{
            Spacer()
            HStack(alignment: .bottom){
                VStack(spacing:5){
                    IconTextView(iconCode: "&#xe681;", size: 25)
                    Text("推荐").font(.system(size: 10))
                }
                .padding(.leading,40)
                .padding(.vertical,4)
                
                Spacer()
                
                VStack(spacing:5){
                    IconTextView(iconCode: "&#xe63a;", size: 25)
                    Text("我的").font(.system(size: 10))
                }
                .padding(.vertical,4)
                
                Spacer()
                
                VStack(spacing:5){
                    IconTextView(iconCode: "&#xe62b;", size: 25)
                    Text("账号").font(.system(size: 10))
                }
                .padding(.trailing,40)
                .padding(.vertical,4)
            }
            .background(Color("bgColorMain"))
        }
    }
}
