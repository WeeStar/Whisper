//
//  UserModel.swift
//  用户信息模型(用于登录后)
//  Whisper
//  Created by WeeStar on 2020/6/11.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import HandyJSON

class UserModel: HandyJSON
{
    required init() {}
    
    /// 用户ID
    var uid:String!
    
    ///用户名
    var uname:String!
    
    ///用户头像
    var ulogo:String!
    
    /// 用户签名
    var usig:String!
}
