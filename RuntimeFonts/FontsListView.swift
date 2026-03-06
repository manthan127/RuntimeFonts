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
                            Text(font.name)
                                .font(font.swiftUIFont(size: 15))
                        }
                    }
                    .padding(.leading)
                }
            }
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FontsListView()
}
