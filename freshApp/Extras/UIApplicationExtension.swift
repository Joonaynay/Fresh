//
//  UIApplicationExtension.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/27/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
