//
//  WebImageView.swift
//  网络图片展示组件
//  Whisper
//
//  Created by WeeStar on 2020/6/16.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI
import Kingfisher

/// 网络图片展示组件
struct WebImageView: SwiftUI.View {
    private var imgUrl:String
    private var errorImgName:String?
    @State private var image:UIImage = UIImage(named: "black")!//初始等待图
    
    
    /// 初始化
    /// - Parameters:
    ///   - imgUrl: 网络图片Url
    ///   - errorImgName: 加载错误展示图片
    init(_ imgUrl:String,errorImgName:String?=nil) {
        self.imgUrl=imgUrl
        self.errorImgName=errorImgName
    }
    
    var body: some SwiftUI.View {
        Image(uiImage: self.image).resizable().onAppear(perform: loadImg)
    }
    
    /// 图片加载
    private func loadImg(){
        if let url = URL(string: self.imgUrl){
            //加载图片
            KingfisherManager.shared
                .retrieveImage(with: url,
                               options:  [
                                .processor(DownsamplingImageProcessor(size: CGSize(width: 600, height: 600))),
                                .cacheOriginalImage
                    ],
                               progressBlock: nil,
                               completionHandler:{
                                   result in
                                   let image = try? result.get().image
                                   if let image = image {
                                       self.image=image
                                   }
                                   else if(self.errorImgName != nil){
                                       self.image=UIImage(named: String(arc4random() % 20 + 1))!
                                   }
                               }
            )
        }
    }
}
