//
//  Utility.swift
//  工具类
//  Whisper
//
//  Created by WeeStar on 2020/6/12.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation

class Utility{
    
    /// 播放时间显示处理
    static func playTimeFormat(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "0:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(Int(secounds) % 60)
        return String(format: "%d:%02d", Min, Sec)
    }
    
    
    /// 播放量显示处理
    static func playNumsFormat(play:String) -> String{
        if let playNum = Int(play){
            if playNum/10000 > 0{
                let f = Double(playNum)/10000.0
                return "\(String(format:"%.1f",f))W"
            }
            else if playNum/1000 > 0{
                let f = Double(playNum)/1000.0
                return "\(String(format:"%.1f",f))K"
            }
        }
        return play.replacingOccurrences(of: "万", with: "W")
    }
    
    
    /// 日期显示处理
    static func chineseTimeFormat(date:Date) -> String {
        //分解日期
        let calendarComponents = Calendar.current.dateComponents([.month,.day,.weekday], from: date)
        let month = calendarComponents.month ?? 0
        let day = calendarComponents.day ?? 0
        let weekday=calendarComponents.weekday! - 1
        var weekdayStr=""
        switch weekday {
        case 1:
            weekdayStr = "周一"
            break
        case 2:
            weekdayStr = "周二"
            break
        case 3:
            weekdayStr = "周三"
            break
        case 4:
            weekdayStr = "周四"
            break
        case 5:
            weekdayStr = "周五"
            break
        case 6:
            weekdayStr = "周六"
            break
        case 7:
            weekdayStr = "周日"
            break
        default:
            break
        }
        return "\(month)月\(day)日 \(weekdayStr)"
    }
    
    
    /// 运营商显示处理
    static func musicSourceFormat(source:MusicSource) -> String{
        switch source{
        case .Netease:
            return "网易云音乐"
        case .Tencent:
            return "QQ音乐"
        case .Bilibili:
            return "Bilibili音乐"
        case .Xiami:
            return "虾米音乐"
        case .Migu:
            return "咪咕音乐"
        case .Kugou:
            return "酷狗音乐"
        default:
            return "未知"
        }
    }
}
