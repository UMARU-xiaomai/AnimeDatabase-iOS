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
                NavigationLink(destination: MangaList(path: .documentsDirectory)){
                    HStack{
                        Image(systemName: "books.vertical.fill")
                        Text("Mangas")
                    }
                }
                NavigationLink(destination: MangaList(path: .documentsDirectory)){
                    HStack{
                        Image(systemName:"play.rectangle.fill")
                        Text("Videos")
                    }
                }
                
            }.navigationTitle("HentaiDatabase")
        }
    }
}

#Preview {
    ContentView()
}
