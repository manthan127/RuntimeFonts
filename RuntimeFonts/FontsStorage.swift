//
//  FontsStorage.swift
//  RuntimeFonts
//
//  Created by Home on 04/03/26.
//

import Foundation
import CoreText

struct FamilyModel: Identifiable {
    let id = UUID()
    let familyName: String
    var fonts: [FontModel]
}

struct FontModel: Hashable {
    let url: URL
    let font: String
}

final class FontsStorage: ObservableObject {
    static let shared = FontsStorage()
    private init() {}
    @Published var families = [FamilyModel]()
    
    func add(_ file: URL) {
        //families.append(contentsOf: CTFont.parse(file: file))
        
        //for file in file.allFontsFile() {
        //    for parsed in CTFont.parse(file: file) {
        //        families.add(parsed)
        //    }
        //}
        
        for parsed in parse(files: file.allFontsFile()) {
            families.add(parsed)
        }
    }
    
    func initialize(_ file: URL) {
        families = parse(files: file.allFontsFile())
    }
}

private extension FontsStorage {
    func parse(files: [URL]) -> [FamilyModel] {
        var dic: [String : [FontModel]] = [:]
        
        for file in files {
            setFontModels(file: file, dic: &dic)
        }
        
        return dic.map {
            FamilyModel(familyName: $0.key, fonts: $0.value)
        }
    }
    
    func setFontModels(file: URL, dic: inout [String : [FontModel]]) {
        let descs = CTFontManagerCreateFontDescriptorsFromURL(file as CFURL)
        guard let descRefs = descs as? [CTFontDescriptor] else { return }
        
        for desc in descRefs {
            let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.preventAutoActivation])
            let postScriptName = CTFontCopyPostScriptName(font) as String
            guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String else { continue }
            //let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String
            
            dic[familyName, default: []].append(FontModel(url: file, font: postScriptName))
        }
    }
}

extension Array where Element == FamilyModel {
    mutating func add(_ newElement: Element) {
        if let ind = self.firstIndex(where: {$0.familyName == newElement.familyName}) {
            for newFont in newElement.fonts {
                if !self[ind].fonts.contains(newFont) {
                    self[ind].fonts.append(newFont)
                }
            }
        } else {
            append(newElement)
        }
    }
}

extension FileManager {
    static var documentDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

//extension CTFont {
//    func parse(file: URL) -> [FamilyModel] {
//        let descs = CTFontManagerCreateFontDescriptorsFromURL(file as CFURL)
//        guard let descRefs = descs as? [CTFontDescriptor] else { return [] }
//        
//        var dic: [String : [String]] = [:]
//        for desc in descRefs {
//            let font = CTFontCreateWithFontDescriptorAndOptions(desc, 0.0, nil, [.preventAutoActivation])
//            let postScriptName = CTFontCopyPostScriptName(font) as String
//            guard let familyName = CTFontCopyAttribute(font, kCTFontFamilyNameAttribute) as? String else { continue }
////                  let style = CTFontCopyAttribute(font, kCTFontStyleNameAttribute) as? String
//            
//            dic[familyName, default: []].append(postScriptName)
//        }
//        
//        return dic.map { d in
//            FamilyModel(url: file, familyName: d.key, fonts: d.value)
//        }
//    }
//}
