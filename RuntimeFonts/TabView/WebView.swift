//
//  WebView.swift
//  RuntimeFonts
//
//  Created by Home on 28/02/26.
//

import SwiftUI
import WebKit
import ZIPFoundation

struct WebView: UIViewRepresentable {
    let url: URL
    
    let webView : WKWebView  = {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return WKWebView(frame: .zero, configuration: configuration)
    }()
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WKDownloadDelegate {
        var url : URL?
        func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String) async -> URL? {
            url = FileManager.documentDirectory.appending(path: suggestedFilename)
            return url
        }
        
        func downloadDidFinish(_ download: WKDownload) {
            if let url {
                let extractURL = url.deletingPathExtension()
                try? FileManager.default.unzipItem(at: url, to: extractURL)
                FontsStorage.shared.add(extractURL)
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading")
        }
        
        func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            download.delegate = self
        }
    }
}

#Preview {
    WebView(url: URL(string: "https://fonts.google.com")!)
}
