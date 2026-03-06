//
//  Extensions.swift
//  RuntimeFonts
//
//  Created by Home on 06/03/26.
//

import UniformTypeIdentifiers

extension URL {
    var children: [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil)) ?? []
    }
    
    var fileType: UTType? {
        try? self.resourceValues(forKeys: [.contentTypeKey]).contentType
    }
    
    func conformsTo(type: UTType)-> Bool {
        fileType?.conforms(to: type) ?? false
    }
    
    func allFontsFile()-> [URL] {
        if self.conformsTo(type: .font) {
            [self]
        } else {
            self.children.flatMap {
                $0.allFontsFile()
            }
        }
    }
}

extension FileManager {
    static var documentDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
