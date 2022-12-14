//
//  ColorExtension.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 29/11/22.
//

import Foundation
import SwiftUI

// Extensions
// Create an extension of Color that receives a Hex Value and converts it into an usable color

extension Color{
    init(hex: Int, alpha: Float){
        let redComponent = (hex >> 16) & 0xFF
        let greenComponent = (hex >> 8) & 0xFF
        let blueComponent = hex & 0xFF
        
        // I can cast Int into CGFloat
        let uiColor = UIColor(red: CGFloat(redComponent)/255,
                              green: CGFloat(greenComponent)/255,
                              blue: CGFloat(blueComponent)/255,
                              alpha: CGFloat(alpha))
        
        self.init(uiColor)
    }
}
// Properties
extension Color{
    static let biomedPrimary = Color(hex: 0xC10000, alpha: 1.0)
    static let biomedButton = Color(hex: 0xA23971, alpha: 1.0)
    static let spacerGray = Color(hex: 0xA5A5A5, alpha: 0.9)
    static let biomedBlack = Color(hex: 0x393939, alpha: 1.0)
}

extension Color {
  var uiColor: UIColor? {
    if #available(iOS 14.0, *) {
      return UIColor(self)
    } else {
      let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
      var hexNumber: UInt64 = 0
      var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
      let result = scanner.scanHexInt64(&hexNumber)
      if result {
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
        return UIColor(red: r, green: g, blue: b, alpha: a)
      } else {
        return nil
      }
    }
  }
}
