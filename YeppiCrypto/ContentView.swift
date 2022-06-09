//
//  ContentView.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      ZStack {
        Color.theme.background
          .ignoresSafeArea()
        VStack {
          Text("Accent Color")
            .foregroundColor(Color.theme.accent)
          Text("Secondary Text Color")
            .foregroundColor(Color.theme.secondaryText)
        }
        .font(.headline)
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
        .preferredColorScheme(.dark)
    }
}
