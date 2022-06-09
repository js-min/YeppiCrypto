//
//  YeppiCryptoApp.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/08.
//

import SwiftUI

@main
struct YeppiCryptoApp: App {
    var body: some Scene {
        WindowGroup {
          NavigationView {
            HomeView()
              .navigationBarHidden(true)
          }
        }
    }
}
