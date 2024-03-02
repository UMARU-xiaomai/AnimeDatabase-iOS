//
//  MangaList.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import SwiftUI
import Zip
import CryptoKit
import AVKit

struct MangaList : View{
    
    @State private var folders:[Folder] = []
    @State private var mangas:[Manga] = []
    
    @State private var thumArr:[UUID:UIImage] = [:]
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
                                .colorMultiply(.accentColor)
                            
                            
                            
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
                                            let cur_tem_path = URL.temporaryDirectory.appendingPathComponent("thums").path + "/\(manga.name.md5()!).dat"
                                            if UIImage(contentsOfFile: cur_tem_path) != nil {
                                                print("already has a thum!")
                                                
                                                
                                                return
                                            }else{
                                                unzipFirstFileFromZip(url:manga.path){dir in
                                                    if let  img = UIImage(contentsOfFile: dir.path){
                                                        do{
                                                            print("###\(cur_tem_path)")
                                                            try checkAndCreateFolder(FolderURL: .temporaryDirectory.appendingPathComponent("thums"))
                                                            if let jpegData = img.jpegData(compressionQuality: 0.3){
                                                                try jpegData.write(to:URL(fileURLWithPath: cur_tem_path))
                                                                
                                                                thumArr[manga.id] = img
                                                            }
                                                        }catch{
                                                            print("failed:\(error)")
                                                        }
                                                        
                                                    }else{
                                                        print("Get cover failed")
                                                    }
                                                }
                                            }
                                        })
                                    if let res = thumArr[manga.id]{
                                        
                                        Image(uiImage: res)
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
            }.toolbar(content: {
                Button(action:{
                    print("test")
                }){
                    Image(systemName: "plus")
                }
            })
            .refreshable{
                Flush()
            }
        }.onAppear(){
            Flush()
            
        }
        .onDisappear(){
//            NSCache<NSURL, UIImage>().removeAllObjects()
            do{
                try Zip.zipFiles(paths: FileManager.default.contentsOfDirectory(at: URL.temporaryDirectory.appendingPathComponent("thums"), includingPropertiesForKeys: nil), zipFilePath:  URL.documentsDirectory.appendingPathComponent("Mangas/thumbnails.zip"), password: nil){progress in
                    if progress == 1{
                        print("##Save thums succeed,you can exit now!")
                    }
                }
            }catch{
                print("Save thum failed")
            }
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
        do{
            try Zip.unzipFile(URL.documentsDirectory.appendingPathComponent("Mangas/thumbnails.zip"), destination: .temporaryDirectory.appendingPathComponent("thums"), overwrite: true, password: nil,progress:{progress in
                if progress != 1{
                    return
                }
                do{
                    try mangas.forEach{ manga in
                        
                        
                        let res = try UIImage(data: Data(contentsOf: URL.temporaryDirectory.appendingPathComponent("thums").appendingPathComponent(manga.name.md5()!+".dat")))
                        if  res != nil {
                            thumArr[manga.id] = res
                        }else{
                            print("thum not found!!!")
                        }
                    }
                }catch{
                    print("unzip thum failed\(error)")
                }
                
            })
        }catch{
            print(error)
        }
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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 153.6))], spacing: 20) {
                    ForEach(folders){folder in
                        VStack{
                            NavigationLink(destination: VideoList(path:folder.path)){
                                
                                    Image(systemName: "folder.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .colorMultiply(.accentColor)
                                
                            }.frame(width: 153.6, height: 86.4)
                            //                            .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Text(folder.name)
                        }
                    }
                    ForEach(videos){video in
                        VStack{
                            NavigationLink(destination: VideoPlayerView(videoURL: video.path)){
                                ZStack{
                                    Rectangle()
                                        .fill(Color(.systemGray))
                                    if let thumbnailImage = generateThumbnail(for: video.path) {
                                            Image(uiImage: thumbnailImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            
                                            // 在这里使用thumbnailImage，比如显示在UIImageView中
                                        } else {
                                            Image(systemName: "play.rectangle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            
                                        }
                                    
                                    
                                }
                            }.frame(width: 153.6, height: 86.4)
                            //                            .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Text(video.name)
                                .lineLimit(1)
                        }
                        
                    }
                }
            }.refreshable{
                Flush()
            }
        }.onAppear(){
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
    func generateThumbnail(for videoURL: URL) -> UIImage? {
        // 创建AVAsset对象
        let asset = AVAsset(url: videoURL)
        
        // 创建AVAssetImageGenerator对象
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        // 获取视频的第一帧作为预览图
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}

extension String{
    func md5() -> String? {
        autoreleasepool{
            if let data = self.data(using: .utf8) {
                let digest = SHA256.hash(data: data)
                let md5String = digest.map { String(format: "%02hhx", $0) }.joined()
                return md5String
            } else {
                return nil
            }
        }
    }
}
