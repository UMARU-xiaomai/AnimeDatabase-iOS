//
//  ZipMangaViewer.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/29.
//

import SwiftUI
import Zip

struct ZipMangaViewer: View {
    @State private var imageFileURLs: [URL] = []
        let zipURL: URL
        
        var body: some View {
            ScrollView {
                       LazyVStack {
                           ForEach(imageFileURLs, id: \.self) { imageURL in
                               Image(uiImage: UIImage(contentsOfFile: imageURL.path)!)
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(maxWidth: .infinity)
                               }
                           }
            }
            .onAppear {
                extractImagesFromZip()
            }
            .onDisappear{
//                cleanupTempDirectory()
            }
        }
        
        func extractImagesFromZip() {
            autoreleasepool {
                do {
                    let unzipDirectory = URL.temporaryDirectory.appendingPathComponent((zipURL.lastPathComponent as NSString).deletingPathExtension)
                    try Zip.unzipFile(zipURL, destination: unzipDirectory, overwrite: true, password: nil,progress:{ (progress) -> () in
                        if(progress != 1){
                            return
                        }
                        
//                        print(unzipDirectory)
//                        print(zipURL)
//                        print(progress)
                        let fileManager = FileManager.default
                        do {
                            let contents = try fileManager.contentsOfDirectory(at: unzipDirectory, includingPropertiesForKeys: nil)
                            
                            let imageFiles = contents.filter { $0.pathExtension.lowercased() == "png" || $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" || $0.pathExtension.lowercased() == "webp" || $0.pathExtension.lowercased() == "gif"}
                            self.imageFileURLs = imageFiles.sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
                        } catch {
                            print("Error extracting images: \(error.localizedDescription)")
                        }
                    })
                } catch {
                    print("Error extracting images: \(error.localizedDescription)")
                }
            }
        }
    

    }
#Preview {
    MangaList(path:.documentsDirectory)
}
