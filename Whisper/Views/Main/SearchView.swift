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
    @State private var searchHis:[String]=["z","b","c","b","c","b","c","b","c","b","c","b","c"]
    @State private var searchKeyWords:String=""
    @State private var commitSearch:Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment:.leading,spacing: 0){
                    HStack(alignment:.bottom){
                        Text("搜索历史").font(.system(size: 20, weight: Font.Weight.bold))
                        Spacer()
                        
                        HStack(alignment:.bottom){
                            Spacer()
                            Text("清空").font(.system(size: 14))
                                .foregroundColor(Color("textColorSub"))
                            Spacer()
                        }
                        .frame(width:55,height: 20)
                        .background(Color(.white).opacity(0.001))
                        .buttonStyle(PlainButtonStyle())
                        .onTapGesture {
                            // 清空历史
                            self.searchHis = ContextService.DelHis()
                        }
                    }
                    .padding(.top,10)
                    .padding(.bottom,6)
                    
                    ForEach(self.searchHis, id: \.self) { sherchHisItem in
                        VStack(alignment:.leading,spacing: 0){
                            Divider()
                                .foregroundColor(Color("textColorSub").opacity(0.5))
                                .frame(height:0.5)
                            
                            HStack{
                                Text(sherchHisItem)
                                    .foregroundColor(Color("ThemeColorMain"))
                                    .font(.system(size: 19))
                                
                                Spacer()
                            }
                            .background(Color(.white).opacity(0.001))
                            .padding(.top,9)
                            .padding(.bottom,9)
                            .onTapGesture {
                                // 使用历史
                                self.searchKeyWords = sherchHisItem
                                self.searchHis = ContextService.AddHis(keyWords: self.searchKeyWords)
                                self.commitSearch = true
                            }
                        }
                    }
                }
                .padding(.horizontal,15)
                    .padding(.bottom,116)//让出底部tab和播放器空间
            }
            .navigationBarTitle("搜索歌曲")
            .navigationBarSearch(self.$searchKeyWords)
        }
    }
}

extension View {
    func navigationBarSearch(_ searchText: Binding<String>) -> some View {
        return overlay(SearchBar(text: searchText).frame(width: 0, height: 0))
    }
}

fileprivate struct SearchBar: UIViewControllerRepresentable {
    @Binding
    var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }
    
    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.searchController = context.coordinator.searchController
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate  {
        @Binding
        var text: String
        let searchController: UISearchController
        
        init(text: Binding<String>) {
            self._text = text
            self.searchController = UISearchController(searchResultsController: nil)
            
            super.init()
            
            //样式调整
            searchController.searchBar.placeholder = "搜索歌曲、歌手、专辑"
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.obscuresBackgroundDuringPresentation = false
            
            //调整光标颜色
            searchController.searchBar.barTintColor = UIColor(named: "ThemeColorMain")
            searchController.searchBar.returnKeyType = .search
            
            for subView in searchController.searchBar.subviews  {
                print(subView)
                for subsubView in subView.subviews  {

                    print(subView)
                    if let bg = subsubView as? UIView {
                        bg.backgroundColor = UIColor.white
                        bg.layer.backgroundColor = UIColor.orange.cgColor
                        bg.layer.borderColor = UIColor.red.cgColor
                        bg.layer.borderWidth = 1
                    }
                    if let textField = subsubView as? UITextField {
                        textField.backgroundColor = UIColor.blue
                        textField.layer.borderColor = UIColor.green.cgColor
                        textField.layer.borderWidth = 1
                    }
                }
            }
            searchController.searchBar.barTintColor = UIColor.yellow
            searchController.searchBar.tintColor = UIColor.black
            

           
            //数据绑定
            searchController.searchBar.delegate = self
            self.searchController.searchBar.text = self.text
        }
        
        //触发搜索
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let text = searchBar.text else { return }
            DispatchQueue.main.async {
                self.text = text
            }
        }
    }
    
    class SearchBarWrapperController: UIViewController {
        var searchController: UISearchController?
        
        override func viewWillAppear(_ animated: Bool) {
            self.parent?.navigationItem.searchController = searchController
            self.parent?.navigationItem.hidesSearchBarWhenScrolling = false
        }
//        override func viewDidAppear(_ animated: Bool) {
//            self.parent?.navigationItem.searchController = searchController
//            self.parent?.navigationItem.hidesSearchBarWhenScrolling = false
//        }
    }
}

extension UISearchController {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
