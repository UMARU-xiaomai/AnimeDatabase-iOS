//
//  ContentView.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/27.
//

import SwiftUI

struct ContentView: View {
//    @State private var presentedParks :[] = []
    
    var body: some View {
        NavigationStack{
            Form {
                NavigationLink(destination: MangaList(path: .documentsDirectory.appendingPathComponent("Mangas"))){
                    HStack{
                        Image(systemName: "books.vertical.fill")
                        Text("Mangas")
                    }
                }
                NavigationLink(destination: VideoList(path: .documentsDirectory.appendingPathComponent("Videos"))){
                    HStack{
                        Image(systemName:"play.rectangle.fill")
                        Text("Videos")
                    }
                }
                
            }.navigationTitle("AnimeDatabase")
        }
    }
}

#Preview {
    ContentView()
}
