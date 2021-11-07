//
//  Keyboard.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/23/21.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
