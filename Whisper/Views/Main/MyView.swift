//
//  MyView.swift
//  我的
//  Whisper
//
//  Created by WeeStar on 2020/6/17.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI


/// 我的页面
struct MyView: View {
    var body: some View {
        ZStack{
            VStack{

                Spacer()
                Rectangle().background(Color.blue).frame(height:200)
            }
            
            Rectangle()
                .blur(radius: 20)
                .opacity(0.7)
                .frame(width:300,height: 400)
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
