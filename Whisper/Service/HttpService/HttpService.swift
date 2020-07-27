//
//  WhisperHttpService.swift
//  网络请求服务
//  Whisper
//
//  Created by WeeStar on 2020/7/27.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import SwiftHTTP
import HandyJSON

class HttpService{
    private static var BaseUrl:String="http://47.105.57.58:8077"
    static let decoder = JSONDecoder()
    
    private static func GetUrl(module:String,methodUrl:String,musicSource:MusicSource) -> String{
        let url = "\(self.BaseUrl)\\\(module)\\\(methodUrl)\\\(musicSource.rawValue)"
        return url
    }
    
    static func Get<T:HandyJSON>(module:String,methodUrl:String,musicSource:MusicSource,
                    params:HTTPParameterProtocol?,
                    successHandler: ((T?) -> Void)? = nil){
        let url = GetUrl(module: module, methodUrl: methodUrl, musicSource: musicSource)
        HTTP.GET(url, parameters: params) { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            do {
                
            } catch let error {
                print("decode json error: \(error)")
            }
        }
    }
    
    static func Post(module:String,methodUrl:String,musicSource:MusicSource,
                    params:HTTPParameterProtocol?,
                    successHandler: ((Dictionary<String,NSObject>) -> Void)? = nil){
        let url = GetUrl(module: module, methodUrl: methodUrl, musicSource: musicSource)
        HTTP.POST(url, parameters: params) { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            
        }
    }
}

class MethodResult <T> where T: HandyJSON{
    var state:Int?
    var error_msg:String?
    var data:T?
}
