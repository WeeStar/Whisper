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
    private var renderingMode:SwiftUI.Image.TemplateRenderingMode?
    @State private var image:UIImage = UIImage(named: "black")!//初始等待图
    
    
    /// 初始化
    /// - Parameters:
    ///   - imgUrl: 网络图片Url
    ///   - errorImgName: 加载错误展示图片
    init(_ imgUrl:String,
         renderingMode:SwiftUI.Image.TemplateRenderingMode? = nil,
         errorImgName:String? = nil) {
        self.imgUrl=imgUrl
        self.renderingMode=renderingMode
        self.errorImgName=errorImgName
    }
    
    var body: some SwiftUI.View {
        Image(uiImage: self.image)
            .renderingMode(renderingMode)
            .resizable()
            .onAppear(perform: loadImg)
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
                                else {
                                    //错误图片
                                    var errImg:UIImage?
                                    if(self.errorImgName != nil){
                                        //指定错误图
                                        errImg=UIImage(named: self.errorImgName!)
                                    }
                                    if(errImg==nil){
                                        //随机错误封面
                                        errImg=UIImage(named: String(arc4random() % 20 + 1))!
                                    }
                                    self.image=errImg!
                                }
                }
            )
        }
    }
}
