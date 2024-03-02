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
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("[ERROR]Documents directory not found")
            return
        }
            // 在应用启动时检查并创建文件夹
        cleanupTempDirectory()
        do{
            try checkAndCreateFolder(FolderURL: documentsDirectory.appendingPathComponent("Mangas"))
            try checkAndCreateFolder(FolderURL: documentsDirectory.appendingPathComponent("Videos"))
        }catch{
            print("check failed")
        }
        }
}
