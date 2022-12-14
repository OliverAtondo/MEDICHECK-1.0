//
//  LabelledDivider.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 30/11/22.
//

import Foundation
import SwiftUI

struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label)
                .foregroundColor(color)
                .font(.body)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }
    }
}

struct LabelledDivider_Previews: PreviewProvider {
    static var previews: some View {
        LabelledDivider(label: "or")
    }
}
