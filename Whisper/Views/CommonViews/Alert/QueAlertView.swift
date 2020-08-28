//
//  TextAlert.swift
//  带询问弹窗
//  Whisper
//
//  Created by WeeStar on 2020/8/28.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct QusAlertView: View {
    var title:String
    var desc:String?
    @Binding var isPresented:Bool
    var successHandler:(()->Void)
    
    var body: some View {
        VStack(spacing:0){
            Text(title)
                .foregroundColor(Color("textColorMain"))
                .font(.headline)
                .padding(.top,20)
            
            if(desc != nil){
                Text(desc!)
                    .lineLimit(2)
                    .foregroundColor(Color("textColorMain"))
                    .font(.footnote)
                    .padding(.top,5)
            }
            
            Divider()
                .foregroundColor(Color("textColorSub").opacity(0.5))
                .frame(height:0.5)
                .padding(.top,20)
            
            HStack{
                Button(action:{
                    self.isPresented = false
                })
                {
                    Spacer()
                    Text("取消")
                        .foregroundColor(Color("ThemeColorMain"))
                        .padding(.horizontal)
                        .padding(.vertical ,5)
                    Spacer()
                }
                
                Divider()
                    .foregroundColor(Color("textColorSub").opacity(0.5))
                    .frame(width:0.5,height:45)
                
                Button(action:{
                    self.successHandler()
                    self.isPresented = false
                })
                {
                    Spacer()
                    Text("确定")
                        .foregroundColor(Color("ThemeColorMain"))
                        .padding(.horizontal)
                        .padding(.vertical ,5)
                    Spacer()
                }
            }
        }
        .frame(width:260)
        .background(BlurView(.systemMaterial))
        .cornerRadius(20)
    }
}

extension View{
    func showQusAlert(title:String,desc:String?,isPresented:Binding<Bool>,successHandler:@escaping (()->Void)) -> some View{
        self.modifier(QusAlertVM(title: title, desc: desc, isPresented: isPresented, successHandler: successHandler))
    }
}

struct QusAlertVM:ViewModifier {
    var title:String
    var desc:String?
    @Binding var isPresented:Bool
    var successHandler:(()->Void)
    
    func body(content: Content) -> some View {
        
        return ZStack{
            content
            .blur(radius: self.isPresented ? 3 : 0)
            .animation(.easeIn(duration: 0.1))
            
            if isPresented{
                VStack{
                    Spacer().onTapGesture {}
                    
                    QusAlertView(title: self.title, desc: self.desc, isPresented: self.$isPresented, successHandler: self.successHandler)
                        .zIndex(1)
                    Group{
                        Spacer()
                        Spacer()
                    }.onTapGesture {}
                }
            }
        }
    }
}
