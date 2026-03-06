//
//  FontConvertible.swift
//  RuntimeFonts
//
//  Created by Home on 04/03/26.
//

import SwiftUI

struct FontConvertible: Hashable {
    internal let name: String
    internal let family: String
    internal let path: URL
    
#if os(macOS)
    internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
    internal typealias Font = UIFont
#endif
    
    internal func font(size: CGFloat) -> Font {
        guard let font = Font(font: self, size: size) else {
            fatalError("Unable to initialize font '\(name)' (\(family))")
        }
        return font
    }
    
#if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
        return SwiftUI.Font.custom(self, size: size)
    }
    
    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
    internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
        return SwiftUI.Font.custom(self, fixedSize: fixedSize)
    }
    
    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
    internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
        return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
    }
#endif
    
    internal func register() {
        CTFontManagerRegisterFontsForURL(path as CFURL, .process, nil)
    }
    
    fileprivate func registerIfNeeded() {
#if os(iOS) || os(tvOS) || os(watchOS)
        if !UIFont.fontNames(forFamilyName: family).contains(name) {
            register()
        }
#elseif os(macOS)
        if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
            register()
        }
#endif
    }
}

internal extension FontConvertible.Font {
    convenience init?(font: FontConvertible, size: CGFloat) {
        font.registerIfNeeded()
        self.init(name: font.name, size: size)
    }
}

internal extension SwiftUI.Font {
    static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
        font.registerIfNeeded()
        return custom(font.name, size: size)
    }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
    static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
        font.registerIfNeeded()
        return custom(font.name, fixedSize: fixedSize)
    }
    
    static func custom(
        _ font: FontConvertible,
        size: CGFloat,
        relativeTo textStyle: SwiftUI.Font.TextStyle
    ) -> SwiftUI.Font {
        font.registerIfNeeded()
        return custom(font.name, size: size, relativeTo: textStyle)
    }
}
