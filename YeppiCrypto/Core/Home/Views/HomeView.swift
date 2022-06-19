//
//  HomeView.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/09.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject private var vm: HomeViewModel
  @State private var showPortfolio: Bool = false // animate right
  @State private var showPortfolioView: Bool = false // new sheet

  
  var body: some View {
    ZStack {
      // background layer
      Color.theme.background
        .ignoresSafeArea()
        .sheet(isPresented: $showPortfolioView) {
          PortfolioView()
            .environmentObject(vm)
        }
      
      // content layer
      VStack {
        
        homeHeader
      
        
        HomeStatView(showPortfolio: $showPortfolio)
        
        SearchBarView(searchText: $vm.searchText)
        
        columnTitles
        
        
        if !showPortfolio {
          allCoinList
            .transition(.move(edge: .leading))
        } else {
          portfolioCoinList
            .transition(.move(edge: .trailing))
        }
        
        
        Spacer(minLength: 0)
        
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeVM)
  }
}


extension HomeView {
  private var homeHeader: some View {
    HStack {
      CircleButtonView(iconName: showPortfolio ? "plus" : "info")
        .animation(.none, value: UUID())
        .onTapGesture {
          if showPortfolio {
            showPortfolioView.toggle()
          }
        }
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
      Spacer()
      Text("Live Prices")
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(Color.theme.accent)
      Spacer()
      CircleButtonView(iconName: "chevron.right")
        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }
  
  private var allCoinList: some View {
    List {
      ForEach(vm.allCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: false)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
      }
    }
    .listStyle(PlainListStyle())
  }
  
  private var portfolioCoinList: some View {
    List {
      ForEach(vm.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
      }
    }
    .listStyle(PlainListStyle())
  }
  
  private var columnTitles: some View {
    HStack {
      HStack {
        Text("Coin")
        Image(systemName: "chevron.down")
          .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1 : 0)
          .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0: 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
        }
      }
      
      Spacer()
      if showPortfolio {
        HStack {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1 : 0)
            .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0: 180))
        }
        .onTapGesture {
          withAnimation(.default) {
            vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
          }
        }
      }
      
      HStack {
        Text("Price")
        Image(systemName: "chevron.down")
          .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1 : 0)
          .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0: 180))
      }
      .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
      .onTapGesture {
        withAnimation(.default) {
          vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
        }
      }
      
      Button {
        withAnimation(.linear(duration: 2.0)) {
          vm.reloadData()
        }
      } label: {
        Image(systemName: "goforward")
      }
      .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .padding(.horizontal)
  }
}
