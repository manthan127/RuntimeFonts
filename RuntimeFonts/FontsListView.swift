//
//  FontsListView.swift
//  RuntimeFonts
//
//  Created by Home on 04/03/26.
//

import SwiftUI

struct FontsListView: View {
    @StateObject var storage = FontsStorage.shared
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(storage.families) { family in
                    Text(family.familyName)
                    VStack(alignment: .leading) {
                        ForEach(family.fonts, id: \.self) { font in
                            Text(font.font)
                                .font(makeFont(font: font, family: family))
                        }
                    }
                    .padding(.leading)
                }
            }
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension FontsListView {
    func makeFont(font: FontModel, family: FamilyModel) -> Font {
        FontConvertible(name: font.font, family: family.familyName, path: font.url).swiftUIFont(size: 15)
    }
}

#Preview {
    FontsListView()
}

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
