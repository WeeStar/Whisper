//
//  WhisperPlayer.swift
//  Whisper
//
//  Created by WeeStar on 2020/7/17.
//  Copyright © 2020 WeeStar. All rights reserved.
//

import Foundation
import Alamofire
 
class WhisperAudio {
 
    private var url: String //网络路径 如果本地路径存在则是本地路径
    private var fileName:String
 
    init (url: String) {
        self.url = url
        self.fileName="WhisperAudio_\(URL(string: self.url)!.lastPathComponent)"
    }
 
    //获取播放路径
    func getUrl() -> String {
        if isExist() {
            return getFilePath()
        }
        return self.url
    }
 
    //通知下载 如果已经存在 不下载
    func postDownload(successHandler: @escaping (String)->Void,
                      errorHandler: @escaping (AFError)->Void) {
        if isExist() {
            successHandler(self.getUrl())
            return
        }
 
        let destination = DownloadRequest.suggestedDownloadDestination(for:.documentDirectory)
        AF.download(url, to: destination)
            .downloadProgress { progress in
                 print("Download Progress: \(progress.fractionCompleted)")
             }
            .response { response in
                if response.error == nil, let audioPath = response.fileURL?.path {
                    successHandler(audioPath)
                }
                else{
                    errorHandler(response.error!)
                }
        }
    }
 
    //是否已经下载
    private func isExist() -> Bool{
        let filePath = getFilePath()
        let exist = FileManager.default.fileExists(atPath:filePath)
        return exist
    }
 
    //通过文件名称 获取文件路径
    private func getFilePath() -> String {
        return PathService.musicCacheDir+self.fileName
    }
}
