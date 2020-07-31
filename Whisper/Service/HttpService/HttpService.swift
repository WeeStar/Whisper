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
    // 服务器地址
    private static var BaseUrl:String="http://47.105.57.58:8077"
    
    /// 构造url
    /// - Parameters:
    ///   - module: 模块
    ///   - methodUrl: 方法
    ///   - musicSource: 音乐源
    /// - Returns: url
    private static func GetUrl(module:String,methodUrl:String,musicSource:MusicSource) -> String{
        let url = "\(self.BaseUrl)/\(module)/\(methodUrl)/\(musicSource.rawValue)"
        return url
    }
    
    public func getName<T:HandyJSON>(param:T) -> Array<T>
    {
        return [param]
    }
    
    /// Get请求
    /// - Parameters:
    ///   - module: 模块
    ///   - methodUrl: 方法
    ///   - musicSource: 音乐源
    ///   - params: 接口参数
    ///   - successHandler: 成功回调
    ///   - failHandler: 失败回调
    static func Get(module:String,methodUrl:String,musicSource:MusicSource,
                    params:HTTPParameterProtocol?,
                    successHandler: ((AnyObject?) -> Void)? = nil,
                    failHandler: ((String) -> Void)? = nil)
    {
        // 构造url
        let url = GetUrl(module: module, methodUrl: methodUrl, musicSource: musicSource)
        
        // get请求
        HTTP.GET(url, parameters: params) { response in
            if let err = response.error {
                // 接口非业务异常
                // todo 弹提示 记日志
                print("error: \(err.localizedDescription)")
                return
            }
            
            // 反序列化成公共接口返回结构
            let dataStr = String(data: response.data, encoding: String.Encoding.utf8)
            let methodRes = MethodResult.deserialize(from: dataStr)
            if(methodRes!.state == 0){
                // 接口业务错误
                if(failHandler != nil){
                    failHandler!(methodRes!.error_msg!)
                }
                else{
                    // todo 弹提示 记日志
                    print("api_error: \(methodRes!.error_msg!)")
                }
            }
            else{
                // 接口成功
                successHandler!(methodRes!.data!)
            }
        }
    }
    
    /// Post请求
    /// - Parameters:
    ///   - module: 模块
    ///   - methodUrl: 方法
    ///   - musicSource: 音乐源
    ///   - params: 接口参数
    ///   - successHandler: 成功回调
    ///   - failHandler: 失败回调
    static func Post(module:String,methodUrl:String,musicSource:MusicSource,
                    params:HTTPParameterProtocol?,
                    successHandler: ((AnyObject?) -> Void)? = nil,
                    failHandler: ((String) -> Void)? = nil)
    {
        // 构造url
        let url = GetUrl(module: module, methodUrl: methodUrl, musicSource: musicSource)
        
        // get请求
        HTTP.POST(url, parameters: params, headers: ["Content-Type" : "application/json"],
                  requestSerializer: JSONParameterSerializer()) { response in
            if let err = response.error {
                // 接口非业务异常
                // todo 弹提示 记日志
                print("error: \(err.localizedDescription)")
                return
            }
            
            // 反序列化成公共接口返回结构
            let dataStr = String(data: response.data, encoding: String.Encoding.utf8)
            let methodRes = MethodResult.deserialize(from: dataStr)
            if(methodRes!.state == 0){
                // 接口业务错误
                if(failHandler != nil){
                    failHandler!(methodRes!.error_msg!)
                }
                else{
                    // todo 弹提示 记日志
                    print("api_error: \(methodRes!.error_msg!)")
                }
            }
            else{
                // 接口成功
                successHandler!(methodRes!.data!)
            }
        }
    }
}

class MethodResult : HandyJSON{
    required init() {}
    
    var state:Int?
    var error_msg:String?
    var data:AnyObject?
}
