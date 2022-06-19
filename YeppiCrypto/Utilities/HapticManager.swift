//
//  HapticManager.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/19.
//

import Foundation
import SwiftUI

class HapticManager {
  static private let generator = UINotificationFeedbackGenerator()
  
  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}
