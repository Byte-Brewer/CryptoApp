//
//  UIAplication.swift
//  CryptoApp
//
//  Created by Nazar Prysiazhnyi on 08.03.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
