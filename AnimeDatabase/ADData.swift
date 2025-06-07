//
//  ADData.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import Foundation
import Zip
import SwiftUI

enum MangaType{
    case pdf
    case zip
}

class common_data:Identifiable{
    let id:UUID
    public let path : URL
    public let name :String
    
    init(path:URL)
    {
        self.id = UUID()
        self.path = path
        self.name = path.lastPathComponent
    }
}

class Manga:common_data{
    public let mangaType : MangaType
    init(path:URL,mangaType:MangaType)
    {
        self.mangaType = mangaType
        super.init(path: path) // 调用父类的初始化函数来初始化 path
       
    }
}

class Video:common_data{
    
}

class Folder:common_data{
    
}

func listFiles<T>(atPath path: URL, passResult: (T) -> Void, passDirectory: (Folder) -> Void) {
    print("[MSG]Start Listing")
    let fileManager = FileManager.default
    do {
        let contents = try fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
        for item in contents {
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    // If it's a directory
                    print("[MSG]Directory: \(item.path)")
                    passDirectory(Folder(path: item))
                } else {
                    // If it's a file
                    let fileName = item.lastPathComponent
                    let fileExtension = item.pathExtension
                    print("[Msg]File Name: \(fileName), Extension: \(fileExtension)")
                    if T.self == Manga.self {
                        if fileExtension == "pdf"{
                            passResult(Manga(path: item,mangaType:.pdf) as! T)
                        }else if fileExtension == "zip" && fileName != "thumbnails.zip"{
                            passResult(Manga(path: item,mangaType: .zip) as! T)
                        }
                            
                    } else if T.self == Video.self && fileExtension == "mp4"{
                        passResult(Video(path: item) as! T)
                    }
                }
            }
        }
    } catch {
        print("[ERROR]Error listing contents of directory: \(error)")
    }
}

func unzipFirstFileFromZip(url: URL,comletion:@escaping (URL) -> Void){
    let unzipDirectory = FileManager.default.temporaryDirectory.appendingPathComponent((url.lastPathComponent as NSString).deletingPathExtension)
    print(unzipDirectory)
    autoreleasepool {
        do{
            try ZipController.instance.addUnzipOperation(zipFilePath:url, destination: unzipDirectory, overwrite: true, password: nil,progress: {progress in
                if progress != 1{
                    return
                }
                print(progress)
                
                
                
                guard let contents = try? FileManager.default.contentsOfDirectory(atPath: unzipDirectory.path) else {
                    print("Failed to get contents of unzipped directory.")
                    return
                }
                
                let fileNames = contents.filter { !$0.hasSuffix("/") }.sorted()
                
                if let firstFileName = fileNames.first {
                    let firstFilePath = unzipDirectory.appendingPathComponent(firstFileName)
//                    print("First file name:", firstFileName)
//                    print("First file path:", firstFilePath)
                    comletion(firstFilePath)
                } else {
                    print("No files found in the zip.")
                    
                }
            })
            
            
        } catch {
            print("Failed to unzip the file.")
            
        }
    }
}

class Thumbnails: Codable{
    private var content :[String:Data]
    
    func SetImg(ofNameMD5 md5:String,uiImg:UIImage){
        content[md5] = uiImg.jpegData(compressionQuality: 0.3)
    }
    func GetImg(ofNameMD5 md5:String) -> UIImage?{
        if let res = content[md5]{
            return UIImage(data: res)
        }else{
            return nil
        }
    }
    init(){
        content = [:]
    }
}

class ZipController{
    static var instance = ZipController()
    private var counter:Int = 0
    private init(){
        
    }
    let queue = DispatchQueue(label: "com.example.unzipQueue")
    var isUnzipping = false
    
    func addUnzipOperation(zipFilePath: URL, destination: URL, overwrite: Bool, password: String?, progress: @escaping((_ progress: Double) -> ())) throws {
        queue.async {
            // 等待前一个解压操作完成
            self.counter += 1
            print("Now queue:\(self.counter)")
            while self.isUnzipping {
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            // 开始解压操作
            self.isUnzipping = true
            autoreleasepool{
                do{
                    try Zip.unzipFile(zipFilePath, destination: destination, overwrite: overwrite, password: password,progress: { ori_progress in
                        progress(ori_progress)
                        if ori_progress == 1{
                            self.counter -= 1
                            print("Now queue:\(self.counter)")
                            self.isUnzipping = false
                        }
                    })
                }catch{
                    print("unzip failed")
                }
            }
        }
    
    
    }
}
func checkAndCreateFolder(FolderURL:URL) throws {
    let fileManager = FileManager.default
        
            // 检查是否已存在""文件夹
            if !fileManager.fileExists(atPath: FolderURL.path) {
                // 若不存在，则创建""文件夹
                try fileManager.createDirectory(at: FolderURL, withIntermediateDirectories: true, attributes: nil)
                print("[MSG] folder created successfully\(FolderURL)")
            } else {
                print("[MSG] folder already exists\(FolderURL)")
            }
        
    }
func cleanupTempDirectory() {
    do {
        let fileManager = FileManager.default
        let tempDir = NSTemporaryDirectory()
        let contents = try fileManager.contentsOfDirectory(atPath: tempDir)
        for item in contents {
            let itemURL = URL(fileURLWithPath: tempDir).appendingPathComponent(item)
            try fileManager.removeItem(at: itemURL)
        }
    } catch {
        print("Error cleaning up temp directory: \(error.localizedDescription)")
    }
}

func resizeImage(image: UIImage, targetWidth: CGFloat) -> UIImage? {
    let aspectRatio = image.size.width / image.size.height
    let targetHeight = targetWidth / aspectRatio
    
    let newSize = CGSize(width: targetWidth, height: targetHeight)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
