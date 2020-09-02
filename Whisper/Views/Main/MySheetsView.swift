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
    @State private var tabSelIdx:Int = MySheetsDataService.shareIns.mySheets.count > 0 ? 1 : 0
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
        .showTextAlert(title: "导入歌单歌单", desc: "在浏览器中复制歌单链接，并在此输入",palaceHolder: "请输入外部歌单链接",isPresented: self.$showTextAlert,
                       successHandler: { inputText in
                        self.AddMySheet(sheetUrl: inputText)
        })
    }
    
    private func AddMySheet(sheetUrl : String){
        var source = MusicSource.Unknow
        var id = ""
        //http://music.163.com/playlist/55427798/56454789/?userid=56454789
        //https://music.163.com/#/playlist?id=740915547
        //https://y.qq.com/n/yqq/playlist/7672279691.html#stat=y_new.index.playlist.pic
        //https://www.kugou.com/yy/special/single/2937682.html
        //https://www.xiami.com/collect/1235128822
        //https://music.migu.cn/v3/music/playlist/181534893?origin=1001001
        
        let pattern = "^http[s]?:\\/\\/(.*?)\\/"
        let matches = sheetUrl.matchingStrings(regex: pattern)
        if(matches.count == 0 || matches[0].count == 0){
            return
        }
        let host = matches[0].last
        switch host {
        case "music.163.com":
            var idPattern = "[\\?|&]id=([^&]*)"
            let idMatches = sheetUrl.matchingStrings(regex: idPattern)
            if(idMatches.count == 0 || idMatches[0].count == 0){
                idPattern = "\\/playlist\\/([^\\/]*)\\/"
            }
            id = "neplaylist_" + idMatches[0].last!
            source = MusicSource.Netease
            break
        case "y.qq.com","music.qq.com":
            let idPattern = "\\/playlist\\/(.*)\\.html"
            let idMatches = sheetUrl.matchingStrings(regex: idPattern)
            if(idMatches.count == 0 || idMatches[0].count == 0){
                return
            }
            id = "qqplaylist_" + idMatches[0].last!
            source = MusicSource.Tencent
            break
        case "www.kugou.com":
            let idPattern = "\\/single\\/(.*?)\\.html"
            let idMatches = sheetUrl.matchingStrings(regex: idPattern)
            if(idMatches.count == 0 || idMatches[0].count == 0){
                return
            }
            id = "kgplaylist_" + idMatches[0].last!
            source = MusicSource.Kugou
            break
        case "www.xiami.com":
            let idPattern = "\\/collect\\/([^\\?]*)"
            let idMatches = sheetUrl.matchingStrings(regex: idPattern)
            if(idMatches.count == 0 || idMatches[0].count == 0){
                return
            }
            id = "xmplaylist_" + idMatches[0].last!
            source = MusicSource.Xiami
            break
        case "music.migu.cn":
            let idPattern = "\\/playlist\\/([^\\?]*)"
            let idMatches = sheetUrl.matchingStrings(regex: idPattern)
            if(idMatches.count == 0 || idMatches[0].count == 0){
                return
            }
            id = "mgplaylist_" + idMatches[0].last!
            source = MusicSource.Migu
            break
        default:
            return
        }
        
        //获取歌单信息
        ApiService.GetSheetInfo(source: source, sheetId: id, completeHandler: {
            sheet in
            DispatchQueue.main.async {
                MySheetsDataService.shareIns.AddMySheet(sheet: sheet)
                self.tabSelIdx = 1
            }
        })
    }
}


extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at:$0).location != NSNotFound
                ? nsString.substring(with: result.range(at:$0))
                : ""
            }
        }
    }
}
