//
//  UIApplication.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/16.
//

import Foundation
import SwiftUI

extension UIApplication {
  
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
}
