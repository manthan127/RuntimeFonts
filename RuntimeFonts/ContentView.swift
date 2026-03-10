//
//  ContentView.swift
//  RuntimeFonts
//
//  Created by Home on 28/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FontsListView()
                .tabItem {
                    Label("Fonts List", systemImage: "folder")
                }
            
            PasteView()
                .tabItem {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }
            
            WebView(url: URL(string: "https://fonts.google.com")!)
//            WebView(url: URL(string: "https://www.dafontfree.io/downfile/gilroy-font/")!)
                .ignoresSafeArea()
                .tabItem {
                    Label("Fonts", systemImage: "globe")
                }
        }
        .onAppear(perform: addFonts)
    }
    
    func addFonts() {
        //        print("----", FileManager.documentDirectory)
        FontsStorage.shared.initialize(FileManager.documentDirectory)
    }
}

#Preview {
    ContentView()
}
