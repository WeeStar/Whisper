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
    public var imgUrl:String
    private var errorImgName:String?
    private var renderingMode:SwiftUI.Image.TemplateRenderingMode?
    private var url:URL?=nil
    private var qulity:ImageQulity
    
    /// 初始化
    /// - Parameters:
    ///   - imgUrl: 网络图片Url
    ///   - errorImgName: 加载错误展示图片
    init(_ imgUrl:String,
         renderingMode:SwiftUI.Image.TemplateRenderingMode? = nil,
         errorImgName:String? = nil,
         qulity:ImageQulity = ImageQulity.Regular) {
        self.imgUrl=imgUrl
        self.renderingMode=renderingMode
        self.errorImgName=errorImgName
        self.qulity=qulity
        if(self.imgUrl != ""){
            self.url = URL(string:self.imgUrl)
        }
    }
    
    var body: some SwiftUI.View {
        Group{
            if(self.url != nil){
                KFImage(self.url!, options:  [
                    .processor(DownsamplingImageProcessor(size: CGSize(width: self.qulity.rawValue, height: self.qulity.rawValue))),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]).placeholder({
                    Image("emptyMusic")
                        .renderingMode(renderingMode)
                        .resizable()
                })
                    .renderingMode(renderingMode)
                    .resizable()
            }
            else{
                Image("emptyMusic")
                    .renderingMode(renderingMode)
                    .resizable()
            }
        }
    }
}

/// 音乐来源枚举
enum ImageQulity:Int
{
    case High=600
    case Regular=400
    case Mideum=200
    case Low=100
}
