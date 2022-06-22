//
//  String.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/22.
//

import Foundation

extension String {
  var removingHTMLOccurances: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
}
