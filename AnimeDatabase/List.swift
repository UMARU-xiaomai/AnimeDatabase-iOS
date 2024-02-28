//
//  MangaList.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import SwiftUI

struct MangaList : View{
    
    @State private var folders:[Folder] = []
    @State private var mangas:[Manga] = []
    let path:URL
    init(path:URL){
        self.path = path
    }
    var body: some View {
        NavigationStack{
            Form {
                ForEach(folders){folder in
                    NavigationLink(destination: MangaList(path:folder.path)){
                        HStack{
                            Image(systemName: "folder.fill")
                            Text(folder.name)
                        }
                    }
                }
                ForEach(mangas){manga in
                    NavigationLink(destination: PDFViewer(pdfURL:manga.path)){
                        HStack{
                            Image(systemName: "book.closed.fill")
                            Text(manga.name)
                        }
                    }
                }
            }
        }.onAppear(){
            Flush()
        }
        Button("Flush"){
            Flush()
        }

    }
    
    func Flush(){
        print("[MSG]Path\(path)")
        mangas = []
        folders = []
        listFiles(atPath: path,
                  passResult:{(manga:Manga) -> Void in
            print("[MSG]Add MG")
            mangas.append(manga)
                    },
                  passDirectory: {(folder:Folder) -> Void in
            print("[MSG]Add Folder")
            folders.append(folder)
                    })
    }
}

struct VideoList : View{
    
    @State private var folders:[Folder] = []
    @State private var videos:[Video] = []
    let path:URL
    init(path:URL){
        self.path = path
    }
    var body: some View {
        NavigationStack{
            Form {
                ForEach(folders){folder in
                    NavigationLink(destination: VideoList(path:folder.path)){
                        HStack{
                            Image(systemName: "folder.fill")
                            Text(folder.name)
                        }
                    }
                }
                ForEach(videos){video in
                    NavigationLink(destination: VideoPlayerView(videoURL: video.path)){
                        HStack{
                            Image(systemName: "book.closed.fill")
                            Text(video.name)
                        }
                    }
                }
            }
        }.onAppear(){
            Flush()
        }
        Button("Flush"){
            Flush()
        }

    }
    
    func Flush(){
        print("[MSG]Path\(path)")
        videos = []
        folders = []
        listFiles(atPath: path,
                  passResult:{(video:Video) -> Void in
            print("[MSG]Add VD")
            videos.append(video)
                    },
                  passDirectory: {(folder:Folder) -> Void in
            print("[MSG]Add Folder")
            folders.append(folder)
                    })
    }
}
