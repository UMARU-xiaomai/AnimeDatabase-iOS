//
//  ADData.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import Foundation

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
                        passResult(Manga(path: item) as! T)
                    } else if T.self == Video.self {
                        passResult(Video(path: item) as! T)
                    }
                }
            }
        }
    } catch {
        print("[ERROR]Error listing contents of directory: \(error)")
    }
}
