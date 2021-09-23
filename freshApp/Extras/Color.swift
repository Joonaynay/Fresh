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
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let secondaryText = Color("SecondaryTextColor")
    let pinkColor = Color("PinkColor")
    let sheetColor = Color("SheetColor")
    
}
