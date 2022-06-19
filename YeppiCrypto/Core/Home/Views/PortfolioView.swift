//
//  PortfolioView.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/18.
//

import SwiftUI

struct PortfolioView: View {
  
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject private var vm: HomeViewModel
  @State private var selectedCoin: Coin? = nil
  @State private var quantityText: String = ""
  @State private var showCheckmark: Bool = false
  
  var body: some View {
    NavigationView {
      ScrollView{
        VStack(alignment: .leading, spacing: 0) {
          SearchBarView(searchText: $vm.searchText)
          coinLogoList
          
          if selectedCoin != nil {
            portfolioInputSection
          }
        }
      }
      .navigationTitle("Edit Portfolio")
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .font(.headline)
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavBarButton
        }
      })
      .onChange(of: vm.searchText) { newValue in
        if newValue == "" {
          removeSelectedCoin()
        }
      }
    }
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeVM)
  }
}

extension PortfolioView {
  private var coinLogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 10) {
        ForEach(vm.allCoins) { coin in
          CoinLogoView(coin: coin)
            .frame(width: 75)
            .padding(4)
            .onTapGesture {
              withAnimation {
                selectedCoin = coin
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundColor(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear)
            )
        }
        
      }
      .frame(height: 120)
      .padding(.leading)
    }
  }
  
  private var currentValue: Double {
    if let quantity = Double(quantityText) {
      return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    return 0
  }
  
  private var portfolioInputSection: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
        Spacer()
        Text(selectedCoin?.currentPrice?.asCurrencyWith6Decimals() ?? "")
      }
      Divider()
      HStack {
        Text("Amount holding:")
        Spacer()
        TextField("Ex. 1.4", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      Divider()
      HStack {
        Text("Current Value:")
        Spacer()
        Text(currentValue.asCurrencyWith2Decimals())
      }
    }
    .animation(.none)
    .padding()
    .font(.headline)
  }
  
  private var trailingNavBarButton: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckmark ? 1 : 0)
      Button {
        didTapSaveButton()
      } label: {
        Text("SAVE")
      }
      .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0)

    }
  }
  
  private func didTapSaveButton() {
    guard let coin = selectedCoin else { return }
    
    // save to portfolio
    
    // show checkmark
    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
    }
    
    // hide keyboard
    UIApplication.shared.endEditing()
    
    // hide checkmark
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation(.easeOut) {
        showCheckmark = false
      }
    }
  }
  
  private func removeSelectedCoin() {
    selectedCoin = nil
    vm.searchText = ""
  }
}
