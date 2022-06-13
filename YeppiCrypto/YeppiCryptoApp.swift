//
//  YeppiCryptoApp.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/08.
//

import SwiftUI

@main
struct YeppiCryptoApp: App {
  
  @StateObject private var vm = HomeViewModel()
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          .navigationBarHidden(true)
      }
      .environmentObject(vm)
    }
  }
}
