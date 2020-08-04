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
}
