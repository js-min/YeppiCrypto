//
//  DetailView.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/20.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: Coin?
  
  var body: some View {
    ZStack {
      if let coin = coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  let coin: Coin
  
  init(coin: Coin) {
    self.coin = coin
    print("Initializing Detail View for \(coin.name)")
  }
  
  var body: some View {
    
    ZStack {
      Text(coin.name ?? "")
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
