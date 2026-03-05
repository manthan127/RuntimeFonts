//
//  PasteView.swift
//  RuntimeFonts
//
//  Created by Home on 28/02/26.
//

import SwiftUI
import RemoteResourceKit
import ZIPFoundation

struct PasteView: View {
    @State private var pastedText: String = ""
    @State private var errorMessage: String?
    
    @State private var progress: Double = 0
    
    @State private var isDownloading = !false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Paste URL")
                .font(.title.bold())
            
            TextEditor(text: $pastedText)
                .frame(height: 200)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4))
                )
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Button(action: validateClipboard) {
                Label("Paste", systemImage: "doc.on.clipboard")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            
            if isDownloading {
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
//                    .animation(.easeInOut(duration: 1.5), value: progress)
            }
            
            
            Spacer()
        }
        .padding()
    }
    
    private func validateClipboard() {
        guard let string = UIPasteboard.general.string else { return }
        guard let url = URL(string: string), UIApplication.shared.canOpenURL(url) else {
            errorMessage = "Clipboard does not contain a valid URL."
            return
        }
        
        pastedText = string
        errorMessage = nil
        
        let group = ResourceGroup(baseURL: FileManager.documentDirectory) {
            File(name: nil, url: url)
                .downloadProgress { p in
                    DispatchQueue.main.async {
                        self.progress = p
                    }
                }
                .onDownloadComplete { url in
                    let dest = url.deletingPathExtension()
                    if url.conformsTo(type: .zip) {
                        do {
                            try FileManager.default.unzipItem(at: url, to: dest)
                            FontsStorage.shared.add(dest)
                        } catch {}
                    } else {
                        FontsStorage.shared.add(url)
                    }
                }
        }
        Task {
            print("start")
            await DownloadSession().download(group)
            print("end")
        }
    }
}

#Preview {
    PasteView()
}
