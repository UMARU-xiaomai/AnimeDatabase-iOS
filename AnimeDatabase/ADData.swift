//
//  ADData.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import Foundation
import Zip

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
                        }else if fileExtension == "zip"{
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
            try Zip.unzipFile(url, destination: unzipDirectory, overwrite: true, password: nil,progress: {progress in
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
                    print("First file name:", firstFileName)
                    print("First file path:", firstFilePath)
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
