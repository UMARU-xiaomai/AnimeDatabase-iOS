//
//  AnimeDatabaseApp.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import SwiftUI

@main
struct AnimeDatabaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
            // 在应用启动时检查并创建""文件夹
        checkAndCreateFolder(name:"Mangas")
        checkAndCreateFolder(name:"Videos")
        }
        
    func checkAndCreateFolder(name:String) {
            let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("[ERROR]Documents directory not found")
                return
            }
            
            let FolderURL = documentsDirectory.appendingPathComponent(name)
            
            do {
                // 检查是否已存在""文件夹
                if !fileManager.fileExists(atPath: FolderURL.path) {
                    // 若不存在，则创建""文件夹
                    try fileManager.createDirectory(at: FolderURL, withIntermediateDirectories: true, attributes: nil)
                    print("[MSG] folder created successfully")
                } else {
                    print("[MSG] folder already exists")
                }
            } catch {
                print("[ERROR]Error creating  folder: \(error)")
            }
        }
}
