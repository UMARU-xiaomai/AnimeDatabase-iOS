//
//  MangaList.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import SwiftUI
import Zip

struct MangaList : View{
    
    @State private var folders:[Folder] = []
    @State private var mangas:[Manga] = []
    @State private var thumbnails:[UUID:UIImage] = [:]
    
    let path:URL
    init(path:URL){
        self.path = path
    }
    var body: some View {
        NavigationStack{
            ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(folders){folder in
                    VStack{
                        NavigationLink(destination: MangaList(path:folder.path)){
                            
                            
                                Image(systemName:"folder.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            
                            
                        }.frame(width: 125, height: 176)
                        //                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        Text(folder.name)
                            .lineLimit(1)
                    }
                }
                ForEach(mangas){manga in
                    VStack{
                        if manga.mangaType == .pdf{
                            NavigationLink(destination: PDFViewer(pdfURL: manga.path),label:{
                                ZStack{
                                    Rectangle()
                                        .fill(Color(.systemGray))
                                    Image(systemName: "book.closed.fill")
                                    
                                }
                            }).frame(width: 125, height: 176)
                            //                            .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }else if manga.mangaType == .zip{
                            NavigationLink(destination: ZipMangaViewer(zipURL: manga.path),label:{
                                ZStack{
                                    Rectangle()
                                        .fill(Color(.systemGray))
                                        .onAppear(perform: {
                                                    unzipFirstFileFromZip(url:manga.path){dir in
                                                
                                                        thumbnails[manga.id] = UIImage(contentsOfFile: dir.path)
                                            }
                                        })
                                    if let nn_cur_img_url = thumbnails[manga.id]{
                                        Image(uiImage: nn_cur_img_url)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        }else{
                                            Image(systemName: "doc.zipper")
                                        }
                                    
                                }
                            }).frame(width: 125, height: 176)
                            //                            .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        
                        Text(manga.name)
                            .lineLimit(1)
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
            ScrollView {
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
                                Image(systemName: "play.rectangle.fill")
                                Text(video.name)
                            }
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

