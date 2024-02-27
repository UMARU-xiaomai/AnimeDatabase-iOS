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
            // 在应用启动时检查并创建"Mangas"文件夹
            checkAndCreateMangasFolder()
        }
        
        func checkAndCreateMangasFolder() {
            let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("[ERROR]Documents directory not found")
                return
            }
            
            let mangasFolderURL = documentsDirectory.appendingPathComponent("Mangas")
            
            do {
                // 检查是否已存在"Mangas"文件夹
                if !fileManager.fileExists(atPath: mangasFolderURL.path) {
                    // 若不存在，则创建"Mangas"文件夹
                    try fileManager.createDirectory(at: mangasFolderURL, withIntermediateDirectories: true, attributes: nil)
                    print("[MSG]Mangas folder created successfully")
                } else {
                    print("[MSG]Mangas folder already exists")
                }
            } catch {
                print("[ERROR]Error creating Mangas folder: \(error)")
            }
        }
}
