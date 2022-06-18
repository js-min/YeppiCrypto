//
//  XMarkButton.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/18.
//

import SwiftUI

struct XMarkButton: View {
  
  @Environment(\.dismiss) var dismiss
  
  
  var body: some View {
    Button {
      print("DEBUG: TAP xmark button")
      dismiss()
    } label: {
      Image(systemName: "xmark")
        .font(.headline)
    }
  }
}

struct XMarkButton_Previews: PreviewProvider {
  static var previews: some View {
    XMarkButton()
  }
}
