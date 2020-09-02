//
//  TextAlert.swift
//  带文本框弹窗
//  Whisper
//
//  Created by WeeStar on 2020/8/28.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import SwiftUI

struct TextAlertView: View {
    var title:String
    var desc:String?
    var palaceHolder:String?
    @Binding var isPresented:Bool
    var successHandler:((String)->Void)
    
    @State var inputText:String = ""
    
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
            
            TextField(self.palaceHolder ?? "请输入", text: self.$inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width:220)
                .padding(.horizontal)
                .padding(.top,20)
                .padding(.bottom,10)
            
            Divider()
                .foregroundColor(Color("textColorSub").opacity(0.5))
                .frame(height:0.5)
            
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
                    self.successHandler(self.inputText)
                    self.isPresented = false
                })
                {
                    Spacer()
                    Text("确定")
                        .foregroundColor(self.inputText == "" ? Color("textColorSub") : Color("ThemeColorMain"))
                        .padding(.horizontal)
                        .padding(.vertical ,5)
                    Spacer()
                }
                .disabled(self.inputText == "")
            }
        }
        .frame(width:260)
        .background(BlurView(.systemMaterial))
        .cornerRadius(10)
    }
}

extension View{
    func showTextAlert(title:String,desc:String?,palaceHolder:String?,isPresented:Binding<Bool>,successHandler:@escaping ((String)->Void)) -> some View{
        self.modifier(TextAlertVM(title: title, desc: desc, isPresented: isPresented, successHandler: successHandler))
    }
}

struct TextAlertVM:ViewModifier {
    var title:String
    var desc:String?
    var palaceHolder:String?
    @Binding var isPresented:Bool
    var successHandler:((String)->Void)
    
    func body(content: Content) -> some View {
        ZStack{
            content
            
            if isPresented{
                VStack{
                    Spacer()
                    HStack(spacing: 0){
                        Spacer()

                        TextAlertView(title: self.title, desc: self.desc, palaceHolder:self.palaceHolder,
                        isPresented: self.$isPresented, successHandler: self.successHandler)
                        
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
                .background(Color(.gray).opacity(0.5))
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {}
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}
