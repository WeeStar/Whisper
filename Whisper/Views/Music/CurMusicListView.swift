//
//  CurMusicListView.swift
//  Whisper
//
//  Created by WeeStar on 2020/8/27.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct CurMusicListView: View {
    @State private var show:Bool = false
    var body: some View {
        VStack{
            Text("abc")
            
            HStack{
                Button("确定"){
                }
                
                Divider()
                
                Button("取消"){
                }
            }
        }
    }
}

struct CurMusicList_Previews: PreviewProvider {
    static var previews: some View {
        CurMusicListView()
    }
}
