//
//  ViewExtension.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 07/12/22.
//

import Foundation
import SwiftUI

extension View{
    // Closing All Active Keyboards
    func closeKeyboards(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    // MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool)-> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    // MARK: Custom Border View With Padding
    func border(_ width: CGFloat,_ color: Color)-> some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    // MARK: Custom Fill View With Padding
    func fillView(_ color: Color)-> some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
    func tabViewStyle(itemColor: Color? = nil,
                      selectedItemColor: Color? = nil) -> some View {
      onAppear {
        let itemAppearance = UITabBarItemAppearance()
        if let uiItemColor = itemColor?.uiColor {
          itemAppearance.normal.iconColor = uiItemColor
          itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: uiItemColor
          ]
        }
        if let uiSelectedItemColor = selectedItemColor?.uiColor {
          itemAppearance.selected.iconColor = uiSelectedItemColor
          itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: uiSelectedItemColor
          ]
        }

        let appearance = UITabBarAppearance()

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
          UITabBar.appearance().scrollEdgeAppearance = appearance
        }
      }
    }
}

