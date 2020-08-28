//
//  SearchView.swift
//  搜索
//  Whisper
//
//  Created by WeeStar on 2020/6/17.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI
import Combine


/// 搜索页面
struct SearchView: View {
    @State private var isSearching:Bool = false
    @State private var searchKeyWords:String=""
    @State private var isShowDelAlert = false
    
    var body: some View {
        SearchNavigation(searchText:self.$searchKeyWords,isEditing: self.$isSearching, search: search, cancel: cancel){
            Group{
                if(!self.isSearching){
                    SearchHisView(isSearching: self.$isSearching, searchKeyWords: self.$searchKeyWords,isDelHis: self.$isShowDelAlert)
                }
                else{
                    SearchResaultView(isSearching: self.$isSearching, searchKeyWords: self.$searchKeyWords)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .showQusAlert(title: "清空", desc: "是否清空搜索记录？", isPresented: self.$isShowDelAlert, successHandler: {
            // 清空历史
            HisDataService.shareIns.DelHis()
        })
    }
    
    
    // Search action. Called when search key pressed on keyboard
    func search() {
        if(self.searchKeyWords == ""){
            return
        }
        self.isSearching = true
        HisDataService.shareIns.AddHis(keyWords: self.searchKeyWords)
    }
    
    // Cancel action. Called when cancel button of search bar pressed
    func cancel() {
        self.isSearching = false
        self.searchKeyWords = ""
    }
}


struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


