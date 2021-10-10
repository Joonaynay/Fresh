//
//  AppColorsModel.swift
//  The Real Ish
//
//  Created by Wendy Buhler on 9/3/21.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    
    let background = Color("BackgroundColor")
    let secondaryText = Color("SecondaryTextColor")
    let blueColor = Color("BlueColor")
    let tabBarColor = Color("TabBarColor")
    let accentColor = Color("AccentColor")
    let lineColor = Color("lineColor")
    let blueTextColor = Color("BlueTextColor")
}
